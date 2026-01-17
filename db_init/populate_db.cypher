// Internet
CREATE (internet:Internet {id: randomUUID(), name: 'Internet'})

// Locations
CREATE (mainBuilding:Location {id: randomUUID(), name:'Main Building', address:'Trg bana Josipa Jelačića 1'})
CREATE (buildingB:Location {id: randomUUID(), name:'Building B', address:'Ulica kneza Branimira 17'})
CREATE (buildingC:Location {id: randomUUID(), name:'Building C', address:'Ulica Thomasa Jeffersona 2'})

// LANs
CREATE (lanCorp:LAN {id: randomUUID(), name:'Corp-LAN', subnet:'192.168.10.0/24', gateway:'192.168.10.1', purpose:'Corporate'})
CREATE (lanFinance:LAN {id: randomUUID(), name:'Finance-LAN', subnet:'192.168.30.0/24', gateway:'192.168.30.1', purpose:'Finance'})
CREATE (lanIT:LAN {id: randomUUID(), name:'IT-LAN', subnet:'192.168.40.0/24', gateway:'192.168.40.1', purpose:'IT'})
CREATE (lanHR:LAN {id: randomUUID(), name:'HR-LAN', subnet:'192.168.50.0/24', gateway:'192.168.50.1', purpose:'HR'})

// Firewalls
CREATE (fwA:Firewall:Device {id: randomUUID(), name:'FW-A', manufacturer:'Cisco', model:'Firepower 1010', serial_number:'FTX2134AB1', status:'running', ip_address:'10.0.0.1', mac_address:'3C:84:6A:2F:91:10', created_at:date(), updated_at:date(), os:'FTD', firewall_type:'next-gen'})
CREATE (fwB:Firewall:Device {id: randomUUID(), name:'FW-B', manufacturer:'Cisco', model:'Firepower 2110', serial_number:'FTX2234BB2', status:'running', ip_address:'10.1.1.10', mac_address:'3C:84:6A:2F:92:20', created_at:date(), updated_at:date(), os:'FTD', firewall_type:'next-gen'})

// Core Routers (in Main Building)
CREATE (coreA:Router:Device {id: randomUUID(), name:'Core-Router-A', manufacturer:'Cisco', model:'ISR 4451-X', serial_number:'ISR4451A92', status:'running', ip_address:'10.0.0.254', mac_address:'00:1B:54:9C:21:01', created_at:date(), updated_at:date(), router_role:'core'})
CREATE (coreB:Router:Device {id: randomUUID(), name:'Core-Router-B', manufacturer:'Cisco', model:'ISR 4451-X', serial_number:'ISR4451B11', status:'not-running', ip_address:'10.1.0.254', mac_address:'00:1B:54:9C:22:01', created_at:date(), updated_at:date(), router_role:'core'})

// Building Routers
CREATE (bldgA:Router:Device {id: randomUUID(), name:'Building-Router-A', manufacturer:'Cisco', model:'ISR 4331', serial_number:'ISR4331B33', status:'running', ip_address:'10.0.1.1', mac_address:'00:1B:54:9C:21:02', created_at:date(), updated_at:date(), router_role:'building'})
CREATE (bldgB:Router:Device {id: randomUUID(), name:'Building-Router-B', manufacturer:'Cisco', model:'ISR 4331', serial_number:'ISR4331B44', status:'running', ip_address:'10.1.1.1', mac_address:'00:1B:54:9C:22:02', created_at:date(), updated_at:date(), router_role:'building'})
CREATE (bldgC:Router:Device {id: randomUUID(), name:'Building-Router-C', manufacturer:'Cisco', model:'ISR 4331', serial_number:'ISR4331C55', status:'running', ip_address:'10.2.1.1', mac_address:'00:1B:54:9C:23:02', created_at:date(), updated_at:date(), router_role:'building'})

// Switches
CREATE (switchA:Switch:Device {id: randomUUID(), name:'Switch-A', manufacturer:'Cisco', model:'Catalyst 9300', serial_number:'SWA001', status:'running', ip_address:'10.0.1.2', mac_address:'00:1B:54:9D:31:01', created_at:date(), updated_at:date()})
CREATE (switchAIT:Switch:Device {id: randomUUID(), name:'Switch-A-IT', manufacturer:'Cisco', model:'Catalyst 9300', serial_number:'SWA004', status:'running', ip_address:'10.0.1.3', mac_address:'00:1B:54:9D:34:01', created_at:date(), updated_at:date()})
CREATE (switchB:Switch:Device {id: randomUUID(), name:'Switch-B', manufacturer:'Cisco', model:'Catalyst 9300', serial_number:'SWB002', status:'running', ip_address:'10.1.1.2', mac_address:'00:1B:54:9D:32:01', created_at:date(), updated_at:date()})
CREATE (switchC:Switch:Device {id: randomUUID(), name:'Switch-C', manufacturer:'Cisco', model:'Catalyst 9300', serial_number:'SWC003', status:'running', ip_address:'10.2.1.2', mac_address:'00:1B:54:9D:33:01', created_at:date(), updated_at:date()})

// Load Balancer (in Building B)
CREATE (lbB:LoadBalancer:Device {id: randomUUID(), name:'LB-B', manufacturer:'F5', model:'BIG-IP 2000s', serial_number:'LBF5B001', status:'running', ip_address:'10.1.1.20', mac_address:'00:94:A1:5E:11:01', created_at:date(), updated_at:date(), lb_type:'application', algorithm:'round-robin'})

// Servers (in Building B)
CREATE (srv1:Server:Device {id: randomUUID(), name:'Server-1', manufacturer:'Dell', model:'PowerEdge R640', serial_number:'SRV001', status:'running', ip_address:'10.1.2.10', mac_address:'D0:94:66:3A:11:01', created_at:date(), updated_at:date(), server_role:'web', os:'Ubuntu 22.04', CPUs_total:16, RAM_total:64})
CREATE (srv2:Server:Device {id: randomUUID(), name:'Server-2', manufacturer:'Dell', model:'PowerEdge R640', serial_number:'SRV002', status:'running', ip_address:'10.1.2.11', mac_address:'D0:94:66:3A:11:02', created_at:date(), updated_at:date(), server_role:'web', os:'Ubuntu 22.04', CPUs_total:16, RAM_total:64})
CREATE (srv3:Server:Device {id: randomUUID(), name:'Server-3', manufacturer:'Dell', model:'PowerEdge R740', serial_number:'SRV003', status:'running', ip_address:'10.1.2.12', mac_address:'D0:94:66:3A:11:03', created_at:date(), updated_at:date(), server_role:'database', os:'Ubuntu 22.04', CPUs_total:32, RAM_total:128})

// Workstations for Switch A (Corp-LAN in Main Building)
CREATE (wsA1:Workstation:Device {id: randomUUID(), name:'WS-A-1', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTA1', status:'running', ip_address:'192.168.10.101', mac_address:'B8:CA:3A:91:4F:11', created_at:date(), updated_at:date(), user:'Ivan Horvat', os:'Windows 11'})
CREATE (wsA2:Workstation:Device {id: randomUUID(), name:'WS-A-2', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTA2', status:'running', ip_address:'192.168.10.102', mac_address:'B8:CA:3A:92:4F:22', created_at:date(), updated_at:date(), user:'Ana Kovač', os:'Windows 11'})
CREATE (wsA3:Workstation:Device {id: randomUUID(), name:'WS-A-3', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTA3', status:'running', ip_address:'192.168.10.103', mac_address:'B8:CA:3A:93:4F:33', created_at:date(), updated_at:date(), user:'Marko Babić', os:'Windows 11'})
CREATE (wsA4:Workstation:Device {id: randomUUID(), name:'WS-A-4', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTA4', status:'running', ip_address:'192.168.10.104', mac_address:'B8:CA:3A:94:4F:44', created_at:date(), updated_at:date(), user:'Petra Marić', os:'Windows 11'})
CREATE (wsA5:Workstation:Device {id: randomUUID(), name:'WS-A-5', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTA5', status:'running', ip_address:'192.168.10.105', mac_address:'B8:CA:3A:95:4F:55', created_at:date(), updated_at:date(), user:'Luka Novak', os:'Windows 11'})
CREATE (wsA6:Workstation:Device {id: randomUUID(), name:'WS-A-6', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTA6', status:'running', ip_address:'192.168.10.106', mac_address:'B8:CA:3A:96:4F:66', created_at:date(), updated_at:date(), user:'Maja Radić', os:'Windows 11'})

// Workstations for Switch A-IT (IT-LAN in Main Building)
CREATE (wsAIT1:Workstation:Device {id: randomUUID(), name:'WS-A-IT-1', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTAIT1', status:'running', ip_address:'192.168.40.101', mac_address:'B8:CA:3A:C1:4F:11', created_at:date(), updated_at:date(), user:'Stjepan Matić', os:'Windows 11'})
CREATE (wsAIT2:Workstation:Device {id: randomUUID(), name:'WS-A-IT-2', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTAIT2', status:'running', ip_address:'192.168.40.102', mac_address:'B8:CA:3A:C2:4F:22', created_at:date(), updated_at:date(), user:'Kristina Tomić', os:'Windows 11'})
CREATE (wsAIT3:Workstation:Device {id: randomUUID(), name:'WS-A-IT-3', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTAIT3', status:'running', ip_address:'192.168.40.103', mac_address:'B8:CA:3A:C3:4F:33', created_at:date(), updated_at:date(), user:'Josip Đurić', os:'Windows 11'})
CREATE (wsAIT4:Workstation:Device {id: randomUUID(), name:'WS-A-IT-4', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTAIT4', status:'running', ip_address:'192.168.40.104', mac_address:'B8:CA:3A:C4:4F:44', created_at:date(), updated_at:date(), user:'Andrea Mihalić', os:'Windows 11'})
CREATE (wsAIT5:Workstation:Device {id: randomUUID(), name:'WS-A-IT-5', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTAIT5', status:'running', ip_address:'192.168.40.105', mac_address:'B8:CA:3A:C5:4F:55', created_at:date(), updated_at:date(), user:'Davor Sokol', os:'Windows 11'})

// Workstations for Switch B (Finance-LAN in Building B)
CREATE (wsB1:Workstation:Device {id: randomUUID(), name:'WS-B-1', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTB1', status:'running', ip_address:'192.168.30.101', mac_address:'B8:CA:3A:A1:4F:11', created_at:date(), updated_at:date(), user:'Nikola Perić', os:'Windows 11'})
CREATE (wsB2:Workstation:Device {id: randomUUID(), name:'WS-B-2', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTB2', status:'running', ip_address:'192.168.30.102', mac_address:'B8:CA:3A:A2:4F:22', created_at:date(), updated_at:date(), user:'Ivana Jurić', os:'Windows 11'})
CREATE (wsB3:Workstation:Device {id: randomUUID(), name:'WS-B-3', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTB3', status:'running', ip_address:'192.168.30.103', mac_address:'B8:CA:3A:A3:4F:33', created_at:date(), updated_at:date(), user:'Tomislav Blažević', os:'Windows 11'})
CREATE (wsB4:Workstation:Device {id: randomUUID(), name:'WS-B-4', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTB4', status:'running', ip_address:'192.168.30.104', mac_address:'B8:CA:3A:A4:4F:44', created_at:date(), updated_at:date(), user:'Katarina Vuković', os:'Windows 11'})
CREATE (wsB5:Workstation:Device {id: randomUUID(), name:'WS-B-5', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTB5', status:'running', ip_address:'192.168.30.105', mac_address:'B8:CA:3A:A5:4F:55', created_at:date(), updated_at:date(), user:'Ante Šimić', os:'Windows 11'})
CREATE (wsB6:Workstation:Device {id: randomUUID(), name:'WS-B-6', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTB6', status:'running', ip_address:'192.168.30.106', mac_address:'B8:CA:3A:A6:4F:66', created_at:date(), updated_at:date(), user:'Marija Knežević', os:'Windows 11'})

// Workstations for Switch C (HR-LAN in Building C)
CREATE (wsC1:Workstation:Device {id: randomUUID(), name:'WS-C-1', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTC1', status:'running', ip_address:'192.168.50.101', mac_address:'B8:CA:3A:B1:4F:11', created_at:date(), updated_at:date(), user:'Dario Petrović', os:'Windows 11'})
CREATE (wsC2:Workstation:Device {id: randomUUID(), name:'WS-C-2', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTC2', status:'running', ip_address:'192.168.50.102', mac_address:'B8:CA:3A:B2:4F:22', created_at:date(), updated_at:date(), user:'Lucija Grgić', os:'Windows 11'})
CREATE (wsC3:Workstation:Device {id: randomUUID(), name:'WS-C-3', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTC3', status:'running', ip_address:'192.168.50.103', mac_address:'B8:CA:3A:B3:4F:33', created_at:date(), updated_at:date(), user:'Filip Bošnjak', os:'Windows 11'})
CREATE (wsC4:Workstation:Device {id: randomUUID(), name:'WS-C-4', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTC4', status:'running', ip_address:'192.168.50.104', mac_address:'B8:CA:3A:B4:4F:44', created_at:date(), updated_at:date(), user:'Sara Pavlović', os:'Windows 11'})
CREATE (wsC5:Workstation:Device {id: randomUUID(), name:'WS-C-5', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTC5', status:'running', ip_address:'192.168.50.105', mac_address:'B8:CA:3A:B5:4F:55', created_at:date(), updated_at:date(), user:'Mate Lovrić', os:'Windows 11'})
CREATE (wsC6:Workstation:Device {id: randomUUID(), name:'WS-C-6', manufacturer:'Dell', model:'OptiPlex 7090', serial_number:'DOPTC6', status:'running', ip_address:'192.168.50.106', mac_address:'B8:CA:3A:B6:4F:66', created_at:date(), updated_at:date(), user:'Ema Kralj', os:'Windows 11'})

// Internet and Firewall connections
CREATE (internet)-[:CONNECTED_TO]->(fwA)
CREATE (fwA)-[:LOCATED_IN]->(mainBuilding)

// Firewall to Core Routers
CREATE (fwA)-[:CONNECTED_TO]->(coreA)
CREATE (fwA)-[:CONNECTED_TO]->(coreB)
CREATE (coreA)-[:LOCATED_IN]->(mainBuilding)
CREATE (coreB)-[:LOCATED_IN]->(mainBuilding)

// Core Routers to Building Routers
CREATE (coreA)-[:CONNECTED_TO]->(bldgA)
CREATE (coreB)-[:CONNECTED_TO]->(bldgA)
CREATE (coreA)-[:CONNECTED_TO]->(bldgB)
CREATE (coreB)-[:CONNECTED_TO]->(bldgB)
CREATE (coreA)-[:CONNECTED_TO]->(bldgC)
CREATE (coreB)-[:CONNECTED_TO]->(bldgC)
CREATE (bldgA)-[:LOCATED_IN]->(mainBuilding)
CREATE (bldgB)-[:LOCATED_IN]->(buildingB)
CREATE (bldgC)-[:LOCATED_IN]->(buildingC)

// Building B Router to Firewall B
CREATE (bldgB)-[:CONNECTED_TO]->(fwB)
CREATE (fwB)-[:LOCATED_IN]->(buildingB)

// Firewall B to Load Balancer
CREATE (fwB)-[:CONNECTED_TO]->(lbB)
CREATE (lbB)-[:LOCATED_IN]->(buildingB)

// Load Balancer to Servers
CREATE (lbB)-[:CONNECTED_TO]->(srv1)
CREATE (lbB)-[:CONNECTED_TO]->(srv2)
CREATE (lbB)-[:CONNECTED_TO]->(srv3)
CREATE (srv1)-[:LOCATED_IN]->(buildingB)
CREATE (srv2)-[:LOCATED_IN]->(buildingB)
CREATE (srv3)-[:LOCATED_IN]->(buildingB)

// Building Routers to Switches
CREATE (bldgA)-[:CONNECTED_TO]->(switchA)
CREATE (bldgA)-[:CONNECTED_TO]->(switchAIT)
CREATE (bldgB)-[:CONNECTED_TO]->(switchB)
CREATE (bldgC)-[:CONNECTED_TO]->(switchC)
CREATE (switchA)-[:LOCATED_IN]->(mainBuilding)
CREATE (switchAIT)-[:LOCATED_IN]->(mainBuilding)
CREATE (switchB)-[:LOCATED_IN]->(buildingB)
CREATE (switchC)-[:LOCATED_IN]->(buildingC)
CREATE (switchA)-[:PART_OF_LAN]->(lanCorp)
CREATE (switchAIT)-[:PART_OF_LAN]->(lanIT)
CREATE (switchB)-[:PART_OF_LAN]->(lanFinance)
CREATE (switchC)-[:PART_OF_LAN]->(lanHR)

// Switch A to Workstations
CREATE (switchA)-[:CONNECTED_TO]->(wsA1)
CREATE (switchA)-[:CONNECTED_TO]->(wsA2)
CREATE (switchA)-[:CONNECTED_TO]->(wsA3)
CREATE (switchA)-[:CONNECTED_TO]->(wsA4)
CREATE (switchA)-[:CONNECTED_TO]->(wsA5)
CREATE (switchA)-[:CONNECTED_TO]->(wsA6)
CREATE (wsA1)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsA2)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsA3)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsA4)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsA5)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsA6)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsA1)-[:PART_OF_LAN]->(lanCorp)
CREATE (wsA2)-[:PART_OF_LAN]->(lanCorp)
CREATE (wsA3)-[:PART_OF_LAN]->(lanCorp)
CREATE (wsA4)-[:PART_OF_LAN]->(lanCorp)
CREATE (wsA5)-[:PART_OF_LAN]->(lanCorp)
CREATE (wsA6)-[:PART_OF_LAN]->(lanCorp)

// Switch A-IT to Workstations
CREATE (switchAIT)-[:CONNECTED_TO]->(wsAIT1)
CREATE (switchAIT)-[:CONNECTED_TO]->(wsAIT2)
CREATE (switchAIT)-[:CONNECTED_TO]->(wsAIT3)
CREATE (switchAIT)-[:CONNECTED_TO]->(wsAIT4)
CREATE (switchAIT)-[:CONNECTED_TO]->(wsAIT5)
CREATE (wsAIT1)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsAIT2)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsAIT3)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsAIT4)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsAIT5)-[:LOCATED_IN]->(mainBuilding)
CREATE (wsAIT1)-[:PART_OF_LAN]->(lanIT)
CREATE (wsAIT2)-[:PART_OF_LAN]->(lanIT)
CREATE (wsAIT3)-[:PART_OF_LAN]->(lanIT)
CREATE (wsAIT4)-[:PART_OF_LAN]->(lanIT)
CREATE (wsAIT5)-[:PART_OF_LAN]->(lanIT)

// Switch B to Workstations
CREATE (switchB)-[:CONNECTED_TO]->(wsB1)
CREATE (switchB)-[:CONNECTED_TO]->(wsB2)
CREATE (switchB)-[:CONNECTED_TO]->(wsB3)
CREATE (switchB)-[:CONNECTED_TO]->(wsB4)
CREATE (switchB)-[:CONNECTED_TO]->(wsB5)
CREATE (switchB)-[:CONNECTED_TO]->(wsB6)
CREATE (wsB1)-[:LOCATED_IN]->(buildingB)
CREATE (wsB2)-[:LOCATED_IN]->(buildingB)
CREATE (wsB3)-[:LOCATED_IN]->(buildingB)
CREATE (wsB4)-[:LOCATED_IN]->(buildingB)
CREATE (wsB5)-[:LOCATED_IN]->(buildingB)
CREATE (wsB6)-[:LOCATED_IN]->(buildingB)
CREATE (wsB1)-[:PART_OF_LAN]->(lanFinance)
CREATE (wsB2)-[:PART_OF_LAN]->(lanFinance)
CREATE (wsB3)-[:PART_OF_LAN]->(lanFinance)
CREATE (wsB4)-[:PART_OF_LAN]->(lanFinance)
CREATE (wsB5)-[:PART_OF_LAN]->(lanFinance)
CREATE (wsB6)-[:PART_OF_LAN]->(lanFinance)

// Switch C to Workstations
CREATE (switchC)-[:CONNECTED_TO]->(wsC1)
CREATE (switchC)-[:CONNECTED_TO]->(wsC2)
CREATE (switchC)-[:CONNECTED_TO]->(wsC3)
CREATE (switchC)-[:CONNECTED_TO]->(wsC4)
CREATE (switchC)-[:CONNECTED_TO]->(wsC5)
CREATE (switchC)-[:CONNECTED_TO]->(wsC6)
CREATE (wsC1)-[:LOCATED_IN]->(buildingC)
CREATE (wsC2)-[:LOCATED_IN]->(buildingC)
CREATE (wsC3)-[:LOCATED_IN]->(buildingC)
CREATE (wsC4)-[:LOCATED_IN]->(buildingC)
CREATE (wsC5)-[:LOCATED_IN]->(buildingC)
CREATE (wsC6)-[:LOCATED_IN]->(buildingC)
CREATE (wsC1)-[:PART_OF_LAN]->(lanHR)
CREATE (wsC2)-[:PART_OF_LAN]->(lanHR)
CREATE (wsC3)-[:PART_OF_LAN]->(lanHR)
CREATE (wsC4)-[:PART_OF_LAN]->(lanHR)
CREATE (wsC5)-[:PART_OF_LAN]->(lanHR)
CREATE (wsC6)-[:PART_OF_LAN]->(lanHR)
