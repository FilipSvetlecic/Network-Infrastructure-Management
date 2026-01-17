from flask import render_template, request, jsonify
from app import app
from app.services.graph_database_service import graph_database_service

@app.route("/")
def index():
    devices = graph_database_service.get_network_devices()
    return render_template("index.html", devices=devices)

@app.route("/api/filter", methods=["GET"])
def get_filtered_devices():
    search = str(request.args.get("search", ""))
    device_type = str(request.args.get("type", ""))
    status = str(request.args.get("status", ""))
    location = str(request.args.get("location", ""))
    lan = str(request.args.get("lan", ""))
    
    search = search if search else None
    device_type = device_type if device_type else None
    status = status if status else None
    location = location if location else None
    lan = lan if lan else None

    try:
        filteredDevices = graph_database_service.get_filtered_devices(search, device_type, status, location, lan)
        return jsonify(filteredDevices), 200
    except Exception as e:
        return jsonify({"error": "Filtering failed"}), 500
    

@app.route("/api/devices/<device_id>", methods=["GET"])
def get_device(device_id):
    device = graph_database_service.get_device_by_id(device_id)
    if device:
        return jsonify(device)
    return jsonify({"error": "Device not found"}), 404

@app.route("/api/devices", methods=["POST"])
def create_device():
    data = request.json
    try:
        device = graph_database_service.create_device(data)
        return jsonify(device), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route("/api/devices/<device_id>", methods=["PUT"])
def update_device(device_id):
    data = request.json
    try:
        device = graph_database_service.update_device(device_id, data)
        if device:
            return jsonify(device)
        return jsonify({"error": "Device not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route("/api/devices/<device_id>", methods=["DELETE"])
def delete_device(device_id):
    try:
        success = graph_database_service.delete_device(device_id)
        if success:
            return jsonify({"message": "Device deleted successfully"})
        return jsonify({"error": "Device not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route("/api/locations", methods=["GET"])
def get_locations():
    locations = graph_database_service.get_all_locations()
    return jsonify(locations)

@app.route("/api/LANs", methods=["GET"])
def get_LANs():
    lans = graph_database_service.get_all_lans()
    return jsonify(lans)

@app.route("/api/connectable-devices", methods=["GET"])
def get_connectable_devices():
    devices = graph_database_service.get_connectable_devices()
    return jsonify(devices)

@app.route("/api/devices/<device_id>/connections", methods=["GET"])
def get_device_connections(device_id):
    connections = graph_database_service.get_device_connections(device_id)
    return jsonify(connections)

@app.route("/api/devices/<device_id>/dependencies", methods=["GET"])
def check_device_dependencies(device_id):
    dependencies = graph_database_service.check_device_dependencies(device_id)
    return jsonify(dependencies)