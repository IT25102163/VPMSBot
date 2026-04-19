<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String hName = (String) session.getAttribute("name");
  String hRole = (String) session.getAttribute("role");
  if (hName == null) hName = "User";
  if (hRole == null) hRole = "user";
  boolean isAdmin = "admin".equals(hRole);

  // READ FROM SERVLET — not from DAO directly
  List<ParkingRecord> history = (List<ParkingRecord>) request.getAttribute("sessions");
  if (history == null) history = new ArrayList<>();

  ParkingRecord editRecord = (ParkingRecord) request.getAttribute("editSession");

  // Keep search values for showing in form
  String searchPlate  = request.getParameter("plate")  != null ? request.getParameter("plate")  : "";
  String searchStatus = request.getParameter("status") != null ? request.getParameter("status") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Parking History</title>
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
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;margin-bottom:20px;}
.card-hdr{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
/* EDIT PANEL */
.edit-panel{padding:20px;background:#FFFBEB;border-bottom:1px solid #fcd34d;}
.edit-banner{font-size:13px;color:#92400e;font-weight:600;margin-bottom:14px;display:flex;align-items:center;gap:8px;}
.form-row{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;}
.form-group{display:flex;flex-direction:column;gap:5px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input,.form-select{padding:9px 12px;border:1.5px solid var(--border);border-radius:7px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#fff;outline:none;width:100%;}
.form-input:focus,.form-select:focus{border-color:var(--accent);}
.edit-actions{display:flex;gap:10px;margin-top:14px;}
.btn-save{background:linear-gradient(135deg,#F59E0B,#d97706);color:#fff;border:none;padding:9px 20px;border-radius:7px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;}
.btn-cancel-link{background:transparent;border:1.5px solid var(--border);color:var(--muted);padding:9px 16px;border-radius:7px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;}
/* SEARCH BAR */
.search-bar{display:flex;gap:10px;padding:16px 20px;border-bottom:1px solid var(--border);background:#fafbff;align-items:center;}
.search-input{padding:9px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;background:#fff;outline:none;width:200px;}
.search-input:focus{border-color:var(--accent);}
.search-select{padding:9px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;outline:none;background:#fff;}
.search-select:focus{border-color:var(--accent);}
.btn-search{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;padding:9px 20px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;}
.btn-clear{background:transparent;border:1.5px solid var(--border);color:var(--muted);padding:9px 14px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;}
.search-result-info{font-size:12px;color:var(--accent);font-weight:600;margin-left:4px;}
/* TABLE */
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 16px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:12px 16px;vertical-align:middle;}
.vtag{font-size:11px;font-weight:700;background:var(--navy);color:#fff;padding:3px 9px;border-radius:5px;}
.slot-tag{font-size:11px;font-weight:700;color:var(--accent);background:var(--accent-light);padding:3px 9px;border-radius:5px;}
.s-paid{background:var(--green-light);color:#15803d;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700;}
.s-pend{background:var(--amber-light);color:#b45309;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700;}
.del-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}
.edit-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;border:1.5px solid #fcd34d;background:#FEF3C7;color:#92400e;text-decoration:none;display:inline-flex;transition:all 0.15s;}
.edit-btn:hover{background:#F59E0B;color:#fff;border-color:#F59E0B;}
.alert{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;}
.alert-s{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
.empty-row td{text-align:center;color:var(--muted);padding:36px!important;font-size:13px;}
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
    <a class="sb-item" href="security.jsp"><div class="sb-ico">🔐</div>Security</a>
    <a class="sb-item active" href="history"><div class="sb-ico">📋</div>Parking History</a>
    <a class="sb-item" href="billing"><div class="sb-ico">💳</div>Billing</a>
    <a class="sb-item" href="feedback.jsp"><div class="sb-ico">💬</div>Feedback</a>
    <a class="sb-item" href="reports.jsp"><div class="sb-ico">📊</div>Reports</a>
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= hName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= hName %></div><div class="sb-urole"><%= hRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Parking History</h1><p>Complete vehicle entry and exit records</p></div>
    <a href="#" onclick="if(confirm('Are you sure you want to logout?'))window.location.href='logout'" class="btn-logout">⏏ Logout</a>
  </header>

  <div class="content">
    <% if ("true".equals(request.getParameter("updated"))) { %>
    <div class="alert alert-s">✅ Record updated successfully!</div>
    <% } %>

    <div class="card">
      <div class="card-hdr">
        <div class="card-title"><div class="card-ico">📋</div>All Parking Records</div>
        <span style="font-size:12px;color:var(--muted);font-weight:600;"><%= history.size() %> records
          <% if (!searchPlate.isEmpty() || !searchStatus.isEmpty()) { %>
          <span style="color:var(--accent);">— filtered</span>
          <% } %>
        </span>
      </div>

      <!-- EDIT PANEL -->
      <% if (editRecord != null && isAdmin) { %>
      <div class="edit-panel">
        <div class="edit-banner">✏️ Editing Record #<%= editRecord.getId() %></div>
        <form action="history" method="post">
          <input type="hidden" name="action" value="update"/>
          <input type="hidden" name="id" value="<%= editRecord.getId() %>"/>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Vehicle Plate</label>
              <input class="form-input" type="text" name="vehiclePlate"
                     value="<%= editRecord.getVehiclePlate() != null ? editRecord.getVehiclePlate() : "" %>"
                     oninput="this.value=this.value.toUpperCase()"/>
            </div>
            <div class="form-group">
              <label class="form-label">Slot Number</label>
              <input class="form-input" type="text" name="slotNumber"
                     value="<%= editRecord.getSlotNumber() != null ? editRecord.getSlotNumber() : "" %>"/>
            </div>
            <div class="form-group">
              <label class="form-label">Payment Status</label>
              <select class="form-select" name="paymentStatus">
                <option value="pending" <%= "pending".equals(editRecord.getStatus()) ? "selected" : "" %>>Pending</option>
                <option value="paid"    <%= "paid".equals(editRecord.getStatus())    ? "selected" : "" %>>Paid</option>
              </select>
            </div>
          </div>
          <div class="edit-actions">
            <a href="history" class="btn-cancel-link">Cancel</a>
            <button type="submit" class="btn-save">Save Changes →</button>
          </div>
        </form>
      </div>
      <% } %>

      <!-- SEARCH BAR -->
      <form action="history" method="get">
        <div class="search-bar">
          <input class="search-input" type="text" name="plate"
                 placeholder="Search by plate..."
                 value="<%= searchPlate %>"/>
          <select class="search-select" name="status">
            <option value="">All Status</option>
            <option value="paid"    <%= "paid".equals(searchStatus)    ? "selected" : "" %>>Paid</option>
            <option value="pending" <%= "pending".equals(searchStatus) ? "selected" : "" %>>Pending</option>
          </select>
          <button type="submit" class="btn-search">Search</button>
          <a href="history" class="btn-clear">Clear</a>
          <% if (!searchPlate.isEmpty() || !searchStatus.isEmpty()) { %>
          <span class="search-result-info"><%= history.size() %> result(s) found</span>
          <% } %>
        </div>
      </form>

      <!-- TABLE -->
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Vehicle</th>
            <th>Slot</th>
            <th>Entry Time</th>
            <th>Exit Time</th>
            <th>Duration</th>
            <th>Status</th>
            <% if (isAdmin) { %><th>Actions</th><% } %>
          </tr>
        </thead>
        <tbody>
          <% if (history.isEmpty()) { %>
          <tr class="empty-row">
            <td colspan="<%= isAdmin ? 8 : 7 %>">
              <% if (!searchPlate.isEmpty() || !searchStatus.isEmpty()) { %>
              No records found for "<%= searchPlate %>" — try a different search.
              <% } else { %>
              No parking history records yet.
              <% } %>
            </td>
          </tr>
          <% } else { %>
          <% for (ParkingRecord r : history) { %>
          <tr>
            <td style="color:var(--muted);font-size:12px;font-weight:600;"><%= r.getId() %></td>
            <td><span class="vtag"><%= r.getVehiclePlate() != null ? r.getVehiclePlate() : "—" %></span></td>
            <td><span class="slot-tag"><%= r.getSlotNumber() != null ? r.getSlotNumber() : "—" %></span></td>
            <td style="font-size:12px;"><%= r.getEntryTime() != null ? r.getEntryTime().toString().replace("T", " ") : "—" %></td>
            <td style="font-size:12px;color:var(--muted);"><%= r.getExitTime() != null ? r.getExitTime().toString().replace("T", " ") : "—" %></td>
            <td style="font-size:12px;"><%= r.getDurationMins() > 0 ? r.getDurationMins() + " min" : "—" %></td>
            <td>
              <% if ("paid".equals(r.getStatus())) { %>
              <span class="s-paid">Paid</span>
              <% } else { %>
              <span class="s-pend"><%= r.getStatus() != null ? r.getStatus() : "—" %></span>
              <% } %>
            </td>
            <% if (isAdmin) { %>
            <td style="display:flex;gap:6px;">
              <a href="history?action=edit&id=<%= r.getId() %>" class="edit-btn">Edit</a>
              <form action="history" method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="id" value="<%= r.getId() %>"/>
                <button type="submit" class="del-btn"
                        onclick="return confirm('Delete this record?')">Delete</button>
              </form>
            </td>
            <% } %>
          </tr>
          <% } %>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
