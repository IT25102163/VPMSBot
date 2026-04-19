<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String secName = (String) session.getAttribute("name");
  String secRole = (String) session.getAttribute("role");
  if (secName == null) secName = "User";
  if (secRole == null) secRole = "user";

  // Auto-fill vehicle and user ID from session/DB
  int secUserId = 0;
  String secVehicle = "";
  try {
    secUserId = (int) session.getAttribute("userId");
    User secUser = new UserDAO().getUserById(secUserId);
    if (secUser != null && secUser.getVehicleNo() != null && !secUser.getVehicleNo().isEmpty())
      secVehicle = secUser.getVehicleNo();
  } catch(Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Security</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
<style>
:root{--bg:#F0F4FF;--surface:#fff;--navy:#0f172a;--accent:#6366f1;--accent-light:#eef2ff;--green:#22C55E;--green-light:#DCFCE7;--amber:#F59E0B;--amber-light:#FEF3C7;--red:#EF4444;--red-light:#FEE2E2;--text:#0f172a;--muted:#64748b;--border:#e2e8f0;--shadow:0 2px 12px rgba(15,23,42,0.06);}
*{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;}
.sidebar{width:240px;background:linear-gradient(180deg,#0f172a,#1e293b);min-height:100vh;display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:100;}
.sb-logo{padding:24px 20px 20px;border-bottom:1px solid rgba(255,255,255,0.07);}
.sb-brand{display:flex;align-items:center;gap:11px;}
.sb-icon{width:38px;height:38px;background:linear-gradient(135deg,#6366f1,#8b5cf6);border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;flex-shrink:0;font-size:17px;}
.sb-name{font-size:17px;font-weight:700;color:#fff;}
.sb-sec{padding:18px 14px 4px;}
.sb-lbl{font-size:10px;font-weight:700;letter-spacing:1.4px;color:rgba(255,255,255,0.22);text-transform:uppercase;padding:0 8px;margin-bottom:4px;}
.sb-item{display:flex;align-items:center;gap:10px;padding:9px 10px;border-radius:9px;color:rgba(255,255,255,0.45);font-size:13px;font-weight:500;transition:all 0.15s;margin-bottom:1px;text-decoration:none;}
.sb-item:hover{background:rgba(255,255,255,0.07);color:rgba(255,255,255,0.85);}
.sb-item.active{background:rgba(99,102,241,0.25);color:#fff;border:1px solid rgba(99,102,241,0.3);}
.sb-ico{width:30px;height:30px;border-radius:7px;background:rgba(255,255,255,0.07);display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0;}
.sb-item.active .sb-ico{background:linear-gradient(135deg,#6366f1,#8b5cf6);}
.sb-div{height:1px;background:rgba(255,255,255,0.07);margin:6px 14px;}
.sb-foot{margin-top:auto;padding:14px;border-top:1px solid rgba(255,255,255,0.07);}
.sb-user{display:flex;align-items:center;gap:9px;padding:10px 11px;background:rgba(255,255,255,0.04);border-radius:10px;}
.sb-av{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#fff;flex-shrink:0;}
.sb-uname{font-size:12px;font-weight:600;color:#fff;}
.sb-urole{font-size:11px;color:rgba(255,255,255,0.3);}
.main{margin-left:240px;flex:1;display:flex;flex-direction:column;}
.topbar{background:rgba(255,255,255,0.92);border-bottom:1px solid var(--border);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.tb-left h1{font-size:19px;font-weight:700;}
.tb-left p{font-size:12px;color:var(--muted);}
.btn-logout{background:#FEE2E2;color:#dc2626;border:1.5px solid #fca5a5;padding:8px 16px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;}
.btn-logout:hover{background:#dc2626;color:#fff;}
.content{padding:24px 28px;flex:1;}
.stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:20px;}
.stat-card{background:var(--surface);border-radius:14px;padding:18px;border:1px solid var(--border);display:flex;flex-direction:column;gap:10px;}
.stat-lbl{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;}
.stat-val{font-size:28px;font-weight:700;}
.badge{display:inline-flex;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px;}
.bg{background:var(--green-light);color:#15803d;}
.br{background:var(--red-light);color:#dc2626;}
.ba{background:var(--amber-light);color:#b45309;}
.top-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:20px;}
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;margin-bottom:20px;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;}
.card-body{padding:20px;}
.form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input,.form-select{padding:10px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;outline:none;width:100%;}
.form-input:focus,.form-select:focus{border-color:var(--accent);background:#fff;}
.form-input.locked{background:#f1f5f9;color:var(--text);font-weight:600;cursor:not-allowed;}
.form-input::placeholder{color:#cbd5e1;}
.btn-entry{background:linear-gradient(135deg,#22C55E,#16a34a);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;margin-top:4px;}
.btn-exit{background:linear-gradient(135deg,#EF4444,#dc2626);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;margin-top:4px;}
.btn-refresh{padding:7px 14px;border-radius:7px;font-size:12px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;font-family:'DM Sans',sans-serif;color:var(--text);}
.no-vehicle{background:#FEF3C7;border:1px solid #fcd34d;border-radius:8px;padding:10px 13px;font-size:12px;color:#92400e;margin-bottom:12px;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:11px 14px;vertical-align:middle;}
.vtag{font-size:11px;font-weight:700;background:var(--navy);color:#fff;padding:3px 9px;border-radius:5px;}
.in-badge{background:var(--green-light);color:#15803d;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700;}
.out-badge{background:#f1f5f9;color:var(--muted);padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700;}
</style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-logo"><div class="sb-brand"><div class="sb-icon">P</div><div class="sb-name">ParkSmart</div></div></div>
  <div class="sb-sec">
    <div class="sb-lbl">Main</div>
    <a class="sb-item" href="home.jsp"><div class="sb-ico">⬛</div>Dashboard</a>
    <a class="sb-item" href="register"><div class="sb-ico">👤</div>User Registration</a>
    <a class="sb-item" href="slots"><div class="sb-ico">🅿️</div>Parking Slots</a>
    <a class="sb-item" href="reservations"><div class="sb-ico">📅</div>Reservations</a>
  </div>
  <div class="sb-div"></div>
  <div class="sb-sec">
    <div class="sb-lbl">System</div>
    <a class="sb-item active" href="security.jsp"><div class="sb-ico">🔐</div>Security</a>
    <a class="sb-item" href="history"><div class="sb-ico">📋</div>Parking History</a>
    <a class="sb-item" href="billing"><div class="sb-ico">💳</div>Billing</a>
    <a class="sb-item" href="feedback.jsp"><div class="sb-ico">💬</div>Feedback</a>
    <a class="sb-item" href="reports.jsp"><div class="sb-ico">📊</div>Reports</a>
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= secName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= secName %></div><div class="sb-urole"><%= secRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Security & Access Control</h1><p>Authorize vehicle entry and exit</p></div>
    <a href="#" onclick="if(confirm('Are you sure you want to logout?'))window.location.href='logout'" class="btn-logout">⏏ Logout</a>
  </header>

  <div class="content">
    <!-- STATS -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-lbl">Currently Parked</div>
        <div class="stat-val" id="statParked" style="color:#6366f1;">—</div>
        <span class="badge ba">Live count</span>
      </div>
      <div class="stat-card">
        <div class="stat-lbl">Free Slots</div>
        <div class="stat-val" id="statFree" style="color:#22C55E;">—</div>
        <span class="badge bg">Available</span>
      </div>
      <div class="stat-card">
        <div class="stat-lbl">Total Log Entries</div>
        <div class="stat-val" id="statLog" style="color:#EF4444;">—</div>
        <span class="badge br">Records</span>
      </div>
    </div>

    <!-- ENTRY / EXIT FORMS -->
    <div class="top-grid">

      <!-- VEHICLE ENTRY -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title">
            <div class="card-ico" style="background:#DCFCE7;">🟢</div>Vehicle Entry
          </div>
        </div>
        <div class="card-body">
          <div id="entryAlert"></div>
          <% if (secVehicle.isEmpty()) { %>
          <div class="no-vehicle">⚠️ No vehicle registered on your account.</div>
          <% } %>
          <div class="form-group">
            <label class="form-label">Vehicle Number</label>
            <input class="form-input locked" id="entryVehicle" type="text"
                   value="<%= secVehicle %>" readonly/>
          </div>
          <div class="form-group">
            <label class="form-label">User ID</label>
            <input class="form-input locked" id="entryUserId" type="text"
                   value="<%= secUserId %>" readonly/>
          </div>
          <div class="form-group">
            <label class="form-label">Vehicle Type</label>
            <select class="form-select" id="entryType">
              <option value="Car">Car</option>
              <option value="Motorbike">Motorbike</option>
              <option value="Van">Van</option>
              <option value="Three-Wheeler">Three-Wheeler</option>
            </select>
          </div>
          <button class="btn-entry" onclick="recordEntry()">🟢 Record Entry</button>
        </div>
      </div>

      <!-- VEHICLE EXIT -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title">
            <div class="card-ico" style="background:#FEE2E2;">🔴</div>Vehicle Exit
          </div>
        </div>
        <div class="card-body">
          <div id="exitAlert"></div>
          <div class="form-group">
            <label class="form-label">Vehicle Number</label>
            <input class="form-input locked" id="exitVehicle" type="text"
                   value="<%= secVehicle %>" readonly/>
          </div>
          <div style="background:#f8fafc;border:1.5px solid var(--border);border-radius:9px;padding:14px;margin-bottom:14px;font-size:12px;color:var(--muted);">
            Click exit to record departure and free the parking slot.
          </div>
          <button class="btn-exit" onclick="recordExit()">🔴 Record Exit</button>
        </div>
      </div>

    </div>

    <!-- ACCESS LOG -->
    <div class="card">
      <div class="card-hdr">
        <div class="card-title"><div class="card-ico" style="background:#eef2ff;">📋</div>Access Log</div>
        <button class="btn-refresh" onclick="loadLog()">🔄 Refresh</button>
      </div>
      <table>
        <thead><tr><th>Vehicle</th><th>Type</th><th>Slot</th><th>Entry Time</th><th>Exit Time</th><th>Status</th></tr></thead>
        <tbody id="logBody"><tr><td colspan="6" style="text-align:center;color:var(--muted);padding:24px;">Loading...</td></tr></tbody>
      </table>
    </div>

    <!-- CURRENTLY PARKED -->
    <div class="card">
      <div class="card-hdr">
        <div class="card-title"><div class="card-ico" style="background:#DCFCE7;">🚗</div>Currently Parked</div>
        <span class="badge bg" id="stackCount">0 vehicles</span>
      </div>
      <table>
        <thead><tr><th>Vehicle</th><th>Slot</th><th>Entry Time</th></tr></thead>
        <tbody id="stackBody"><tr><td colspan="3" style="text-align:center;color:var(--muted);padding:24px;">No vehicles parked.</td></tr></tbody>
      </table>
    </div>
  </div>
</div>

<script>
const BASE     = '<%= request.getContextPath() %>/';
const VEHICLE  = '<%= secVehicle %>';
const USER_ID  = '<%= secUserId %>';

function showAlert(id, msg, type) {
  const colors = {success:'#DCFCE7', error:'#FEE2E2', warning:'#FEF3C7'};
  const texts  = {success:'#15803d', error:'#dc2626', warning:'#b45309'};
  document.getElementById(id).innerHTML =
    '<div style="padding:10px 14px;border-radius:8px;font-size:13px;font-weight:500;margin-bottom:12px;background:'+colors[type]+';color:'+texts[type]+'">' + msg + '</div>';
  setTimeout(() => { document.getElementById(id).innerHTML = ''; }, 4000);
}

async function recordEntry() {
  if (!VEHICLE) { showAlert('entryAlert','No vehicle registered on your account.','warning'); return; }

  const type = document.getElementById('entryType').value;
  try {
    const res  = await fetch(BASE + 'security/entry', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'vehicleNumber=' + encodeURIComponent(VEHICLE) +
            '&userId='       + encodeURIComponent(USER_ID) +
            '&vehicleType='  + encodeURIComponent(type)
    });
    const data = await res.json();
    if (data.success) {
      showAlert('entryAlert', '✅ Entry recorded! Slot: ' + data.slotId, 'success');
      loadLog(); loadStack(); loadStats();
    } else {
      showAlert('entryAlert', '❌ ' + data.message, 'error');
    }
  } catch(e) { showAlert('entryAlert', '❌ Server error.', 'error'); }
}

async function recordExit() {
  if (!VEHICLE) { showAlert('exitAlert','No vehicle registered on your account.','warning'); return; }

  try {
    const res  = await fetch(BASE + 'security/exit', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'vehicleNumber=' + encodeURIComponent(VEHICLE)
    });
    const data = await res.json();
    if (data.success) {
      showAlert('exitAlert', '✅ Exit recorded! Slot ' + data.slotId + ' is now free.', 'success');
      loadLog(); loadStack(); loadStats();
    } else {
      showAlert('exitAlert', '❌ ' + data.message, 'error');
    }
  } catch(e) { showAlert('exitAlert', '❌ Server error.', 'error'); }
}

async function loadLog() {
  try {
    const data = await (await fetch(BASE + 'security/log')).json();
    document.getElementById('statLog').textContent = data.length;
    const body = document.getElementById('logBody');
    if (!data.length) {
      body.innerHTML = '<tr><td colspan="6" style="text-align:center;color:#64748b;padding:24px;">No records yet.</td></tr>';
      return;
    }
    body.innerHTML = data.map(e =>
      '<tr>' +
      '<td><span class="vtag">' + e.vehicle + '</span></td>' +
      '<td style="color:#64748b;font-size:12px;">' + e.type + '</td>' +
      '<td><code style="font-size:11px;background:#f1f5f9;padding:3px 7px;border-radius:5px;">' + e.slot + '</code></td>' +
      '<td style="font-size:12px;">' + e.entry + '</td>' +
      '<td style="font-size:12px;color:#64748b;">' + (e.exit || '—') + '</td>' +
      '<td><span class="' + (e.status === 'IN' ? 'in-badge' : 'out-badge') + '">' + e.status + '</span></td>' +
      '</tr>'
    ).join('');
  } catch(e) {}
}

async function loadStack() {
  try {
    const data = await (await fetch(BASE + 'security/stack')).json();
    document.getElementById('stackCount').textContent = data.length + ' vehicles';
    document.getElementById('statParked').textContent = data.length;
    const body = document.getElementById('stackBody');
    if (!data.length) {
      body.innerHTML = '<tr><td colspan="3" style="text-align:center;color:#64748b;padding:24px;">No vehicles parked.</td></tr>';
      return;
    }
    body.innerHTML = data.map(e =>
      '<tr>' +
      '<td><span class="vtag">' + e.vehicle + '</span></td>' +
      '<td><code style="font-size:11px;background:#f1f5f9;padding:3px 7px;border-radius:5px;">' + e.slot + '</code></td>' +
      '<td style="font-size:12px;">' + e.entry + '</td>' +
      '</tr>'
    ).join('');
  } catch(e) {}
}

async function loadStats() {
  try {
    const data = await (await fetch(BASE + 'security/slots')).json();
    document.getElementById('statFree').textContent = data.filter(s => s.free).length;
  } catch(e) {}
}

loadLog(); loadStack(); loadStats();
</script>
</body>
</html>
