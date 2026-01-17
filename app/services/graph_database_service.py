from ..db import driver
from datetime import date
import uuid

class GraphDatabaseService:
    def __init__(self, driver):
        self.driver = driver
    
    def get_network_devices(self):
        with self.driver.session() as session:
            query = """
            MATCH (d:Device)
            OPTIONAL MATCH (d)-[:LOCATED_IN]->(l:Location)
            OPTIONAL MATCH (d)-[:PART_OF_LAN]->(p:LAN)
            RETURN d.id AS id, 
                d.name AS name,
                labels(d) AS labels,
                d.ip_address AS ip_address, 
                d.status AS status,
                d.manufacturer AS manufacturer,
                d.model AS model,
                d.serial_number AS serial_number,
                d.mac_address AS mac_address,
                l.name AS location,
                p.name AS lan
            ORDER BY d.name
            """

            result = session.run(query)
            devices = []
            
            for record in result:
                labels = record['labels']
                device_type = 'Device'
                for label in labels:
                    if label != 'Device':
                        device_type = label
                        break

                device = {
                    'id': record['id'],
                    'name': record['name'],
                    'type': device_type,
                    'ip_address': record['ip_address'],
                    'status': record['status'],
                    'manufacturer': record['manufacturer'],
                    'model': record['model'],
                    'serial_number': record['serial_number'],
                    'mac_address': record['mac_address'],
                    'location': record['location'],
                    'lan': record['lan']
                }

                devices.append(device)
            return devices
        
    def get_filtered_devices(self, search, device_type, status, location, lan):
        with self.driver.session() as session:
            query = """
            MATCH (d:Device)
            """
            where_clauses = []
            params = {}

            
            if device_type:
                where_clauses.append("d:" + device_type)
                params["device_type"] = device_type

            if status:
                where_clauses.append("d.status = $status")
                params["status"] = status

            if where_clauses:
                query += " WHERE " + " AND ".join(where_clauses)
            query += """
            OPTIONAL MATCH (d)-[:LOCATED_IN]->(loc:Location)
            OPTIONAL MATCH (d)-[:PART_OF_LAN]->(l:LAN)
            """
            
            filter_clauses = []
            if location:
                filter_clauses.append("loc.name = $location")
                params["location"] = location
            
            if lan:
                filter_clauses.append("l.name = $lan")
                params["lan"] = lan
            
            if filter_clauses:
                query += " WITH d, loc, l WHERE " + " AND ".join(filter_clauses)

            query += """
            RETURN
                d.id AS id,
                d.name AS name,
                labels(d) AS labels,
                d.ip_address AS ip_address,
                d.status AS status,
                d.manufacturer AS manufacturer,
                d.model AS model,
                d.serial_number AS serial_number,
                d.mac_address AS mac_address,
                loc.name AS location,
                l.name AS lan
            ORDER BY d.name
                """
            result = session.run(query, params)

            devices = []
            for record in result:
                labels = record['labels']
                device_type = 'Device'
                for label in labels:
                    if label != 'Device':
                        device_type = label
                        break
                device = {
                    'id': record['id'],
                    'name': record['name'],
                    'type': device_type,
                    'ip_address': record['ip_address'],
                    'status': record['status'],
                    'manufacturer': record['manufacturer'],
                    'model': record['model'],
                    'serial_number': record['serial_number'],
                    'mac_address': record['mac_address'],
                    'location': record['location'],
                    'lan': record['lan']
                }
                devices.append(device)
            return devices

    
    def get_device_by_id(self, device_id):
        with self.driver.session() as session:
            query = """
            MATCH (d:Device {id: $device_id})
            OPTIONAL MATCH (d)-[:LOCATED_IN]->(l:Location)
            OPTIONAL MATCH (d)-[:PART_OF_LAN]->(p:LAN)
            RETURN d, labels(d) AS labels, l.name AS location, p.name AS lan
            """
            result = session.run(query, device_id=device_id)

            record = result.single()

            if not record:
                return None
            
            device = dict(record['d'])
            for key, value in device.items():
                if hasattr(value, "isoformat"):
                    device[key] = value.isoformat()

            labels = record['labels']
            for l in labels:
                if l != 'Device':
                    device_type = l
                    break 
                        
            device['type'] = device_type
            device['location'] = record['location']
            device['lan'] = record['lan']
            return device

    def create_device(self, data):
        with self.driver.session() as session:
            device_id = str(uuid.uuid4())
            device_type = data.get('type', 'Device')
            
            now = date.today()
            
            base_props = {
                'id': device_id,
                'name': data['name'],
                'manufacturer': data.get('manufacturer', ''),
                'model': data.get('model', ''),
                'serial_number': data.get('serial_number', ''),
                'status': data.get('status', 'running'),
                'ip_address': data.get('ip_address', ''),
                'mac_address': data.get('mac_address', ''),
                'created_at': now,
                'updated_at': now
            }
            
            if device_type == 'Workstation':
                base_props['os'] = data.get('os', '')
                base_props['user'] = data.get('user', '')
            elif device_type == 'Router':
                base_props['router_role'] = data.get('router_role', '')
            elif device_type == 'Firewall':
                base_props['firewall_type'] = data.get('firewall_type', '')
                base_props['os'] = data.get('os', '')
            elif device_type == 'Server':
                base_props['server_role'] = data.get('server_role', '')
                base_props['os'] = data.get('os', '')
                base_props['CPUs_total'] = data.get('CPUs_total', 0)
                base_props['RAM_total'] = data.get('RAM_total', 0)
            elif device_type == 'LoadBalancer':
                base_props['lb_type'] = data.get('lb_type', '')
                base_props['algorithm'] = data.get('algorithm', '')
            
            if device_type != 'Device':
                labels = "Device:" + device_type
            else:
                labels = "Device"

            query = """
            CREATE (d:""" + labels + """ $props)
            RETURN d.id AS id
            """

            session.run(query, props=base_props)
            
            if data.get('location'):
                location_query = """
                MATCH (d:Device {id: $device_id})
                MATCH (l:Location {name: $location})
                CREATE (d)-[:LOCATED_IN]->(l)
                """
                session.run(location_query, device_id=device_id, location=data['location'])
            
            if data.get('lan'):
                lan_query = """
                MATCH (d:Device {id: $device_id})
                MATCH (lan:LAN {name: $lan})
                CREATE (d)-[:PART_OF_LAN]->(lan)
                """
                session.run(lan_query, device_id=device_id, lan=data['lan'])
            
            if data.get('connected_devices'):
                for target_id in data['connected_devices']:
                    connection_query = """
                    MATCH (d1:Device {id: $device_id})
                    MATCH (d2:Device {id: $target_id})
                    CREATE (d1)-[:CONNECTED_TO]->(d2)
                    """
                    session.run(connection_query, device_id=device_id, target_id=target_id)
            
            return self.get_device_by_id(device_id)
    
    def update_device(self, device_id, data):
        try:
            with self.driver.session() as session:
                allowed_properties = {"id", "name", "manufacturer", "model", "serial_number", "status", "ip_address", "mac_address", "created_at", "updated_at",
                                    "router_role", "user", "os", "server_role", "CPUs_total", "RAM_total", "lb_type", "algorithm", "firewall_type", "name",
                                    "provider"}
                update_props = {}
                for key, value in data.items():
                    if key in allowed_properties:
                        update_props[key] = value

                update_props['updated_at'] = date.today()
                query = """
                MATCH (d:Device {id: $device_id})
                SET d += $props
                RETURN d.id AS id
                """
                
                result = session.run(query, device_id=device_id, props=update_props)
                
                if result.single():
                    if 'location' in data:
                        delete_location_query = """
                        MATCH (d {id: $device_id})
                        OPTIONAL MATCH (d)-[r:LOCATED_IN]->()
                        DELETE r
                        """
                        session.run(delete_location_query, device_id=device_id)
                        if data['location']:
                            location_query = """
                            MATCH (d:Device {id: $device_id})
                            MATCH (l:Location {name: $location})
                            CREATE (d)-[:LOCATED_IN]->(l)
                            """
                            session.run(location_query, device_id=device_id, location=data['location'])
                    
                    if 'lan' in data:
                        delete_lan_query = """
                        MATCH (d {id: $device_id})
                        OPTIONAL MATCH (d)-[r:PART_OF_LAN]->()
                        DELETE r
                        """

                        session.run(delete_lan_query, device_id=device_id)
                        if data['lan']:
                            lan_query = """
                            MATCH (d:Device {id: $device_id})
                            MATCH (lan:LAN {name: $lan})
                            CREATE (d)-[:PART_OF_LAN]->(lan)
                            """
                            session.run(lan_query, device_id=device_id, lan=data['lan'])
                    
                    if 'connected_devices' in data:
                        delete_connections_query = """
                        MATCH (d:Device {id: $device_id})-[r:CONNECTED_TO]-()
                        DELETE r
                        """
                        session.run(delete_connections_query, device_id=device_id)
                        
                        for target_id in data['connected_devices']:
                            connection_query = """
                            MATCH (d1:Device {id: $device_id})
                            MATCH (d2:Device {id: $target_id})
                            CREATE (d1)-[:CONNECTED_TO]->(d2)
                            """
                            session.run(connection_query, device_id=device_id, target_id=target_id)
                    
                    return self.get_device_by_id(device_id)
                
                return None
        except Exception as e:
            print("Update device failed:", e)
            raise
    
    def delete_device(self, device_id):
        with self.driver.session() as session:
            query = """
            MATCH (d:Device {id: $device_id})
            DETACH DELETE d
            RETURN count(d) AS deleted
            """
            result = session.run(query, device_id=device_id)
            record = result.single()
            return record['deleted'] > 0
    
    def get_all_locations(self):
        with self.driver.session() as session:
            query = "MATCH (l:Location) RETURN l.name AS name ORDER BY l.name"
            result = session.run(query)

            locations = []
            for location in result:
                locations.append(
                    location['name']
                )

            return locations

    def get_all_lans(self):
        with self.driver.session() as session:
            query = "MATCH (l:LAN) RETURN l.name AS name ORDER BY l.name"
            result = session.run(query)
            lans = []
            for record in result:
                lans.append(
                    record['name']
                )
            return lans
    
    def get_connectable_devices(self):
        with self.driver.session() as session:
            query = """
            MATCH (d:Device)
            RETURN d.id AS id, d.name AS name, labels(d) AS labels
            ORDER BY d.name
            """
            result = session.run(query)
            
            devices = []
            for record in result:
                labels = record['labels']
                device_type_label = 'Device'
                for label in labels:
                    if label != 'Device':
                        device_type_label = label
                        break
                devices.append({
                    'id': record['id'],
                    'name': record['name'],
                    'type': device_type_label
                })
            return devices
    
    def get_device_connections(self, device_id):
        with self.driver.session() as session:
            query = """
            MATCH (d:Device {id: $device_id})-[:CONNECTED_TO]-(connected:Device)
            RETURN connected.id AS id, connected.name AS name
            """
            result = session.run(query, device_id=device_id)
            devices = []
            for record in result:
                devices.append({
                    'id': record['id'],
                    'name': record['name']
                })
            return devices
    
    def check_device_dependencies(self, device_id):
        with self.driver.session() as session:
            query = """
            MATCH (other:Device)-[:CONNECTED_TO]-(d:Device {id: $device_id})
            RETURN other.name AS name, other.id AS id
            """
            result = session.run(query, device_id=device_id)
            devices = []
            for record in result:
                devices.append({
                    'id': record['id'],
                    'name': record['name']
                })
            return devices

graph_database_service = GraphDatabaseService(driver)