const deviceTable = document.getElementById('device-table');
const infoCard = document.getElementById('device-info');
const searchInput = document.getElementById('search-name');
const typeFilter = document.getElementById('filter-type');
const statusFilter = document.getElementById('filter-status');
const locationFilter = document.getElementById('filter-location');
const lanFilter = document.getElementById('filter-lans');
const addDeviceBtn = document.getElementById('add-device-btn');
const modal = document.getElementById('device-modal');
const modalTitle = document.getElementById('modal-title');
const deviceForm = document.getElementById('device-form');
const closeBtn = document.querySelector('.close');
const cancelBtn = document.getElementById('cancel-btn');
const deviceTypeSelect = document.getElementById('device-type');
const filterBtn = document.getElementById('btn-filter');

document.addEventListener('DOMContentLoaded', () => {
    loadDevices();
    loadLocations();
    loadLANs();
    setupEventListeners();
});

function loadDevices() {
    allDevices = Array.from(document.querySelectorAll('.device-row')).map(row => ({
        element: row,
        id: row.dataset.id,
        name: row.dataset.name,
        type: row.dataset.type,
        ip_address: row.dataset.ip,
        status: row.dataset.status,
        location: row.dataset.location,
        lan: row.dataset.lan
    }));
}

async function loadLocations() {
    try {
        const response = await fetch('/api/locations');
        const locations = await response.json();
        
        const deviceLocationSelect = document.getElementById('device-location');
        locations.forEach(location => {
            const option = document.createElement('option');
            option.value = location;
            option.textContent = location;
            locationFilter.appendChild(option.cloneNode(true));
            deviceLocationSelect.appendChild(option);
        });
    } catch (error) {
        console.error('Error loading locations:', error);
    }
}

async function loadLANs(){
    try{
        const response = await fetch('/api/LANs');
        const lans = await response.json();
        const deviceLanSelect = document.getElementById('device-lan');
        lans.forEach(lan => {
            const option = document.createElement('option');
            option.value = lan;
            option.textContent = lan;
            lanFilter.appendChild(option.cloneNode(true));
            deviceLanSelect.appendChild(option);
        });
    } catch(error){
        console.error('Error loading LANs:', error);
    } 
}

function setupEventListeners() {
    filterBtn.addEventListener('click', applyFilters);
    
    document.querySelectorAll('.device-row').forEach(row => {
        row.addEventListener('click', (e) => {
            if (!e.target.closest('button')) {
                showDeviceInfo(row);
            }
        });
    });
    
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            editDevice(btn.dataset.id);
        });
    });
    
    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            deleteDevice(btn.dataset.id);
        });
    });
    
    addDeviceBtn.addEventListener('click', () => openModal());
    closeBtn.addEventListener('click', closeModal);
    cancelBtn.addEventListener('click', closeModal);
    deviceForm.addEventListener('submit', handleFormSubmit);
    deviceTypeSelect.addEventListener('change', toggleTypeSpecificFields);
    
    window.addEventListener('click', (e) => {
        if (e.target === modal) closeModal();
    });
}

async function showDeviceInfo(row) {
    try {
        const response = await fetch(`/api/devices/${row.dataset.id}`);
        if (!response.ok) throw new Error("Failed to fetch device info");
        const device = await response.json();

        let html = `
            <h3>${device.name}</h3>
            <p><strong>Type:</strong> ${device.type}</p>
            <p><strong>IP Address:</strong> ${device.ip_address}</p>
            <p><strong>Status:</strong> <span class="status-badge status-${device.status}">${device.status}</span></p>
            <p><strong>Manufacturer:</strong> ${device.manufacturer || 'N/A'}</p>
            <p><strong>Model:</strong> ${device.model || 'N/A'}</p>
            <p><strong>Serial Number:</strong> ${device.serial_number || 'N/A'}</p>
            <p><strong>MAC Address:</strong> ${device.mac_address || 'N/A'}</p>
            <p><strong>Location:</strong> ${device.location || 'N/A'}</p>
            <p><strong>LAN:</strong> ${device.lan || 'N/A'}</p>
            <p><strong>Created at:</strong> ${device.created_at || 'N/A'}</p>
            <p><strong>Updated at:</strong> ${device.updated_at || 'N/A'}</p>
        `;

        if (device.type === 'Workstation') {
            html += `
                <p><strong>OS:</strong> ${device.os || 'N/A'}</p>
                <p><strong>User:</strong> ${device.user || 'N/A'}</p>
            `;
        } else if (device.type === 'Router') {
            html += `<p><strong>Router Role:</strong> ${device.router_role || 'N/A'}</p>`;
        } else if (device.type === 'Firewall') {
            html += `
                <p><strong>Firewall Type:</strong> ${device.firewall_type || 'N/A'}</p>
                <p><strong>OS:</strong> ${device.os || 'N/A'}</p>
            `;
        } else if (device.type === 'Server') {
            html += `
                <p><strong>Server Role:</strong> ${device.server_role || 'N/A'}</p>
                <p><strong>OS:</strong> ${device.os || 'N/A'}</p>
                <p><strong>CPUs:</strong> ${device.CPUs_total || 'N/A'}</p>
                <p><strong>RAM:</strong> ${device.RAM_total || 'N/A'}</p>
            `;
        } else if (device.type === 'LoadBalancer') {
            html += `
                <p><strong>LB Type:</strong> ${device.lb_type || 'N/A'}</p>
                <p><strong>Algorithm:</strong> ${device.algorithm || 'N/A'}</p>
            `;
        }

        infoCard.innerHTML = html;
    } catch (error) {
        console.error("Failed to load device info:", error);
    }
}

async function applyFilters() {
    const search = searchInput.value;
    const type = typeFilter.value;
    const status = statusFilter.value;
    const location = locationFilter.value;
    const lan = lanFilter.value;

    const params = new URLSearchParams({
        search,
        type,
        status,
        location,
        lan
    });

    try{
        const response = await fetch(`/api/filter?${params.toString()}`);
        const filteredDevices = await response.json();
        
        if (!response.ok){
            throw new Error('Failed to fetch filtered devices');
        }
        updateDeviceTable(filteredDevices);
        
        infoCard.innerHTML = '<p>Select a device to see details.</p>';
    } catch (error){
        console.error('Error applying filters:', error);
        alert('Error applying filters. Please try again.');
    }
    
}
function updateDeviceTable(devices) {
    const tbody = deviceTable.querySelector('tbody');
    
    tbody.innerHTML = '';
    
    if (devices.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px;">No devices found matching the filters.</td></tr>';
        return;
    }
    
    devices.forEach(device => {
        const row = document.createElement('tr');
        row.className = 'device-row';
        row.dataset.id = device.id;
        row.dataset.name = device.name;
        row.dataset.type = device.type;
        row.dataset.ip = device.ip_address;
        row.dataset.status = device.status;
        row.dataset.location = device.location || 'N/A';
        row.dataset.lan = device.lan || 'N/A';
        
        row.innerHTML = `
            <td>${device.name}</td>
            <td>${device.type}</td>
            <td>${device.ip_address}</td>
            <td><span class="status-badge status-${device.status}">${device.status}</span></td>
            <td>${device.location || 'N/A'}</td>
            <td>${device.lan || 'N/A'}</td>
            <td class="action-buttons">
                <button class="btn-edit" data-id="${device.id}" title="Edit">✏️</button>
                <button class="btn-delete" data-id="${device.id}" title="Delete">🗑️</button>
            </td>
        `;
        
        tbody.appendChild(row);
    });
    
    attachRowEventListeners();
}

function attachRowEventListeners() {
    document.querySelectorAll('.device-row').forEach(row => {
        row.addEventListener('click', (e) => {
            if (!e.target.closest('button')) {
                showDeviceInfo(row);
            }
        });
    });
    
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            editDevice(btn.dataset.id);
        });
    });
    
    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            deleteDevice(btn.dataset.id);
        });
    });
}

function openModal(deviceId = null) {
    modal.style.display = 'block';
    
    
    if (deviceId) {
        modalTitle.textContent = 'Edit Device';
        loadDeviceData(deviceId);
    } else {
        modalTitle.textContent = 'Add New Device';
        deviceForm.reset();
        document.getElementById('device-id').value = '';
    }
    loadConnectableDevices();
    toggleTypeSpecificFields();
}

function closeModal() {
    modal.style.display = 'none';
    deviceForm.reset();
}

function toggleTypeSpecificFields() {
    const type = deviceTypeSelect.value;
    
    document.querySelectorAll('.type-specific').forEach(el => {
        el.style.display = 'none';
    });
    
    if (type === 'Workstation') {
        document.getElementById('workstation-fields').style.display = 'block';
    } else if (type === 'Router') {
        document.getElementById('router-fields').style.display = 'block';
    } else if (type === 'Firewall') {
        document.getElementById('firewall-fields').style.display = 'block';
    } else if (type === 'Server') {
            document.getElementById('server-fields').style.display = 'block';
    } else if (type === 'LoadBalancer') {
            document.getElementById('loadbalancer-fields').style.display = 'block';
    } else if (type === 'Switch') {
            document.getElementById('switch-fields').style.display = 'block';
    }

}

async function loadConnectableDevices(deviceType) {
    try {
        const response = await fetch(`/api/connectable-devices`);
        const devices = await response.json();
        
        const connectionsSelect = document.getElementById('device-connections');
        connectionsSelect.innerHTML = '<option value="">-- Select devices to connect --</option>';
        
        devices.forEach(device => {
            const option = document.createElement('option');
            option.value = device.id;
            option.textContent = `${device.name} (${device.type})`;
            connectionsSelect.appendChild(option);
        });
    } catch (error) {
        console.error('Error loading connectable devices:', error);
    }
}

async function loadDeviceData(deviceId) {
    try {
        const deviceResponse = await fetch(`/api/devices/${deviceId}`);
        const device = await deviceResponse.json();
        const connectionsResponse = await fetch(`/api/devices/${deviceId}/connections`);
        const connections = await connectionsResponse.json();
        
        document.getElementById('device-id').value = device.id;
        document.getElementById('device-name').value = device.name;
        document.getElementById('device-type').value = device.type;
        document.getElementById('device-ip').value = device.ip_address;
        document.getElementById('device-status').value = device.status;
        document.getElementById('device-manufacturer').value = device.manufacturer || '';
        document.getElementById('device-model').value = device.model || '';
        document.getElementById('device-serial').value = device.serial_number || '';
        document.getElementById('device-mac').value = device.mac_address || '';
        document.getElementById('device-location').value = device.location || '';
        document.getElementById('device-lan').value = device.lan || '';
        
        await loadConnectableDevices(device.type);
        
        const connectionsSelect = document.getElementById('device-connections');
        const connectionIds = connections.map(c => c.id);
        Array.from(connectionsSelect.options).forEach(option => {
            if (connectionIds.includes(option.value)) {
                option.selected = true;
            }
        });
        
        if (device.type === 'Workstation') {
            document.getElementById('workstation-fields').style.display = 'block';
            document.getElementById('device-os').value = device.os || '';
            document.getElementById('device-user').value = device.user || '';
        } else if (device.type === 'Router') {
            document.getElementById('router-fields').style.display = 'block';
            document.getElementById('device-router-role').value = device.router_role || '';
        } else if (device.type === 'Firewall') {
            document.getElementById('firewall-fields').style.display = 'block';
            document.getElementById('device-firewall-type').value = device.firewall_type || '';
            document.getElementById('device-fw-os').value = device.os || '';
        } else if (device.type === 'Server') {
            document.getElementById('server-fields').style.display = 'block';
            document.getElementById('device-server-role').value = device.server_role || '';
            document.getElementById('device-server-os').value = device.os || '';
            document.getElementById('device-cpus').value = device.CPUs_total || '';
            document.getElementById('device-ram').value = device.RAM_total || '';
        } else if (device.type === 'LoadBalancer') {
            document.getElementById('loadbalancer-fields').style.display = 'block';
            document.getElementById('device-lb-type').value = device.lb_type || '';
            document.getElementById('device-algorithm').value = device.algorithm || '';
        } else if (device.type === 'Switch') {
            document.getElementById('switch-fields').style.display = 'block';
            document.getElementById('device-ports-total').value = device.ports_total || '';
            document.getElementById('device-ports-used').value = device.ports_used || '';
        }
    } catch (error) {
        console.error('Error loading device data:', error);
    }
}

async function handleFormSubmit(e) {
    e.preventDefault();
    
    const deviceId = document.getElementById('device-id').value;
    const type = document.getElementById('device-type').value;
    
    const data = {
        name: document.getElementById('device-name').value,
        type: type,
        ip_address: document.getElementById('device-ip').value,
        status: document.getElementById('device-status').value,
        manufacturer: document.getElementById('device-manufacturer').value,
        model: document.getElementById('device-model').value,
        serial_number: document.getElementById('device-serial').value,
        mac_address: document.getElementById('device-mac').value,
        location: document.getElementById('device-location').value || null
    };
    
    const lanValue = document.getElementById('device-lan').value;
    if (lanValue) {
        data.lan = lanValue;
    }
    
    const connectionsSelect = document.getElementById('device-connections');
    const selectedConnections = Array.from(connectionsSelect.selectedOptions)
        .map(opt => opt.value)
        .filter(val => val);
    if (selectedConnections.length > 0) {
        data.connected_devices = selectedConnections;
    }
    
    if (type === 'Workstation') {
        data.os = document.getElementById('device-os').value;
        data.user = document.getElementById('device-user').value;
    } else if (type === 'Router') {
        data.router_role = document.getElementById('device-router-role').value;
    } else if (type === 'Firewall') {
        data.firewall_type = document.getElementById('device-firewall-type').value;
        data.os = document.getElementById('device-fw-os').value;
    } else if (type === 'Server') {
        data.server_role = document.getElementById('device-server-role').value;
        data.os = document.getElementById('device-os').value;
        data.CPUs_total = document.getElementById('device-cpus').value;
        data.RAM_total = document.getElementById('device-ram').value;
    } else if (type === 'LoadBalancer') {
        data.lb_type = document.getElementById('device-lb-type').value;
        data.algorithm = document.getElementById('device-algorithm').value;
    } else if (type === 'Switch') {
        data.ports_total = document.getElementById('device-ports-total').value;
        data.ports_used = document.getElementById('device-ports-used').value;
    }
    

        
    try {
        if (deviceId) {
            await updateDevice(deviceId, data);
        } else {
            await createDevice(data);
        }
        
        closeModal();
        location.reload();
    } catch (error) {
        alert('Error saving device: ' + error.message);
    }
}

async function createDevice(data) {
    const response = await fetch('/api/devices', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
    
    if (!response.ok) {
        throw new Error('Failed to create device');
    }
    return response.json();
}

async function updateDevice(deviceId, data) {
    const response = await fetch(`/api/devices/${deviceId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
    
    if (!response.ok) {
        throw new Error('Failed to update device');
    }
    
    return response.json();
}

function editDevice(deviceId) {
    openModal(deviceId);
}

async function deleteDevice(deviceId) {
    try {
        const response = await fetch(`/api/devices/${deviceId}/dependencies`);
        const dependencies = await response.json();
        
        let confirmMessage = 'Are you sure you want to delete this device?';
        
        if (dependencies.length > 0) {
            const deviceNames = dependencies.map(d => d.name).join(', ');
            confirmMessage = `WARNING: The following devices are connected to this device:\n\n${deviceNames}\n\nDeleting this device will remove all these connections. Are you sure you want to continue?`;
        }
        
        if (!confirm(confirmMessage)) {
            return;
        }
        
        const deleteResponse = await fetch(`/api/devices/${deviceId}`, {
            method: 'DELETE'
        });
        
        if (!deleteResponse.ok) {
            throw new Error('Failed to delete device');
        }
        
        location.reload();
    } catch (error) {
        alert('Error deleting device: ' + error.message);
    }
}
