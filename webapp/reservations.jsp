<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String rvName = (String) session.getAttribute("name");
  String rvRole = (String) session.getAttribute("role");
  if (rvName == null) rvName = "User";
  if (rvRole == null) rvRole = "user";

  // Auto-fill vehicle and username from session/DB
  String rvVehicle  = "";
  String rvUsername = (String) session.getAttribute("username");
  if (rvUsername == null) rvUsername = "";
  try {
    int uid = (int) session.getAttribute("userId");
    User rvUser = new UserDAO().getUserById(uid);
    if (rvUser != null && rvUser.getVehicleNo() != null && !rvUser.getVehicleNo().isEmpty())
      rvVehicle = rvUser.getVehicleNo();
  } catch(Exception e) {}

  List<Reservation> resList = (List<Reservation>) request.getAttribute("reservations");
  if (resList == null) resList = new ArrayList<>();
  String preSlotId = request.getParameter("slotId") != null ? request.getParameter("slotId") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Reservations</title>
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
.layout{display:grid;grid-template-columns:360px 1fr;gap:20px;align-items:start;}
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:20px;}
.auto-id-box{background:linear-gradient(135deg,rgba(99,102,241,0.08),rgba(139,92,246,0.05));border:1.5px dashed rgba(99,102,241,0.3);border-radius:9px;padding:12px 16px;display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;}
.auto-id-label{font-size:12px;color:var(--muted);font-weight:500;}
.auto-id-hint{font-size:11px;color:rgba(99,102,241,0.6);}
.auto-id-value{font-size:16px;font-weight:800;color:var(--accent);}
.form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input{padding:10px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;outline:none;width:100%;}
.form-input:focus{border-color:var(--accent);background:#fff;}
.form-input.locked{background:#f1f5f9;color:var(--text);font-weight:600;cursor:not-allowed;}
.form-input::placeholder{color:#cbd5e1;}
.no-vehicle{background:#FEF3C7;border:1px solid #fcd34d;border-radius:8px;padding:10px 13px;font-size:12px;color:#92400e;margin-bottom:12px;}
.btn-submit{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;box-shadow:0 4px 12px rgba(99,102,241,0.3);}
.alert{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;}
.alert-s{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
.alert-e{background:var(--red-light);color:#dc2626;border:1px solid #fca5a5;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:11px 14px;vertical-align:middle;}
.res-id{font-size:13px;font-weight:800;color:var(--accent);}
.vtag{font-size:11px;font-weight:700;background:var(--navy);color:#fff;padding:3px 9px;border-radius:5px;}
.slot-tag{font-size:12px;font-weight:700;color:var(--accent);background:var(--accent-light);padding:4px 10px;border-radius:7px;}
.del-btn{padding:4px 11px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}
.empty{text-align:center;padding:36px;color:var(--muted);font-size:13px;}
.count-b{background:var(--accent-light);color:var(--accent);font-size:12px;font-weight:700;padding:4px 10px;border-radius:20px;}
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
    <a class="sb-item active" href="reservations"><div class="sb-ico">📅</div>Reservations</a>
  </div>
  <div class="sb-div"></div>
  <div class="sb-sec">
    <div class="sb-lbl">System</div>
    <a class="sb-item" href="security.jsp"><div class="sb-ico">🔐</div>Security</a>
    <a class="sb-item" href="history"><div class="sb-ico">📋</div>Parking History</a>
    <a class="sb-item" href="billing"><div class="sb-ico">💳</div>Billing</a>
    <a class="sb-item" href="feedback.jsp"><div class="sb-ico">💬</div>Feedback</a>
    <a class="sb-item" href="reports.jsp"><div class="sb-ico">📊</div>Reports</a>
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= rvName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= rvName %></div><div class="sb-urole"><%= rvRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Reservations</h1><p>Manage parking slot reservations</p></div>
    <a href="#" onclick="if(confirm('Are you sure you want to logout?'))window.location.href='logout'" class="btn-logout">⏏ Logout</a>
  </header>
  <div class="content">
    <% if ("true".equals(request.getParameter("success"))) { %>
    <div class="alert alert-s">✅ Reservation added! Slot is now reserved (yellow).</div>
    <% } %>
    <% if ("true".equals(request.getParameter("error"))) { %>
    <div class="alert alert-e">❌ Failed. Please check the slot ID.</div>
    <% } %>

    <div class="layout">
      <!-- FORM -->
      <div class="card">
        <div class="card-hdr"><div class="card-title"><div class="card-ico">📅</div>New Reservation</div></div>
        <div class="card-body">
          <div class="auto-id-box">
            <div><div class="auto-id-label">Reservation ID</div><div class="auto-id-hint">Auto assigned</div></div>
            <div class="auto-id-value">#<%= String.format("%03d", ReservationServlet.nextId) %></div>
          </div>

          <% if (rvVehicle.isEmpty()) { %>
          <div class="no-vehicle">⚠️ No vehicle registered on your account.</div>
          <% } %>

          <form action="reservations" method="post">
            <input type="hidden" name="action" value="add"/>

            <div class="form-group">
              <label class="form-label">Slot</label>
              <% if (!preSlotId.isEmpty()) { %>
              <!-- Coming from slots page — slot is pre-selected, lock it -->
              <input class="form-input locked" type="text"
                     value="Slot <%= preSlotId %>" readonly/>
              <input type="hidden" name="slotId" value="<%= preSlotId %>"/>
              <% } else { %>
              <!-- Manually entering -->
              <input class="form-input" type="number" name="slotId"
                     placeholder="Enter slot ID" min="1" required/>
              <% } %>
            </div>

            <!-- Vehicle — auto filled, locked -->
            <div class="form-group">
              <label class="form-label">Vehicle Number</label>
              <input class="form-input <%= rvVehicle.isEmpty() ? "" : "locked" %>"
                     type="text" name="vehicle"
                     value="<%= rvVehicle %>"
                     placeholder="<%= rvVehicle.isEmpty() ? "No vehicle registered" : rvVehicle %>"
                     <%= rvVehicle.isEmpty() ? "required" : "readonly" %>/>
            </div>

            <!-- Username — auto filled, locked -->
            <div class="form-group">
              <label class="form-label">Username</label>
              <input class="form-input locked" type="text" name="user"
                     value="<%= rvUsername %>" readonly/>
            </div>

            <button type="submit" class="btn-submit">Confirm Reservation →</button>
          </form>
        </div>
      </div>

      <!-- RESERVATIONS TABLE -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title"><div class="card-ico">📋</div>Current Reservations</div>
          <span class="count-b"><%= resList.size() %> active</span>
        </div>
        <% if (resList.isEmpty()) { %>
        <div class="empty">No reservations yet. Add one using the form.</div>
        <% } else { %>
        <table>
          <thead><tr><th>Res. ID</th><th>Slot</th><th>Vehicle</th><th>User</th><th>Action</th></tr></thead>
          <tbody>
            <% for (Reservation r : resList) { %>
            <tr>
              <td><span class="res-id">#<%= String.format("%03d", r.getReservationId()) %></span></td>
              <td><span class="slot-tag">Slot <%= r.getSlotId() %></span></td>
              <td><span class="vtag"><%= r.getVehicleNo() %></span></td>
              <td style="font-size:12px;color:var(--muted);"><%= r.getUserName() %></td>
              <td>
                <form action="reservations" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="delete"/>
                  <input type="hidden" name="id" value="<%= r.getReservationId() %>"/>
                  <button type="submit" class="del-btn"
                          onclick="return confirm('Cancel this reservation? Slot will be freed.')">
                    Cancel
                  </button>
                </form>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
        <% } %>
      </div>
    </div>
  </div>
</div>
</body>
</html>
