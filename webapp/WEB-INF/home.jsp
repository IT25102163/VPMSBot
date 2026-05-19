<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String sessionName = (String) session.getAttribute("name");
  String sessionRole = (String) session.getAttribute("role");
  if (sessionName == null) sessionName = "User";
  if (sessionRole == null) sessionRole = "user";
  boolean isAdmin = "admin".equals(sessionRole);
  String avatarLetter = sessionName.substring(0,1).toUpperCase();

  // ── Load users from DB ──────────────────
  UserDAO homeUserDAO = new UserDAO();
  List<User> homeUsers = new ArrayList<>();
  try { homeUsers = homeUserDAO.getAllUsers(); } catch(Exception e) {}

  // ── Load slots FRESH from DB every time ─
  ParkingSlotDAO homeSlotDAO = new ParkingSlotDAO();
  List<ParkingSlot> homeSlots = new ArrayList<>();
  int freeSlots = 0, occupiedSlots = 0, reservedSlots = 0;
  try {
    homeSlots = homeSlotDAO.getAllSlots();
    for (ParkingSlot s : homeSlots) {
      if ("Available".equals(s.getStatus()))  freeSlots++;
      else if ("Occupied".equals(s.getStatus()))  occupiedSlots++;
      else if ("Reserved".equals(s.getStatus())) reservedSlots++;
    }
  } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>ParkSmart — Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
<style>
:root{--bg:#F0F4FF;--surface:#fff;--navy:#0f172a;--accent:#6366f1;--accent-light:#eef2ff;--green:#22C55E;--green-light:#DCFCE7;--amber:#F59E0B;--amber-light:#FEF3C7;--red:#EF4444;--red-light:#FEE2E2;--text:#0f172a;--muted:#64748b;--border:#e2e8f0;--shadow:0 2px 12px rgba(15,23,42,0.06);--shadow-md:0 8px 32px rgba(15,23,42,0.10);}
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
.sb-user{display:flex;align-items:center;gap:9px;padding:10px 11px;background:rgba(255,255,255,0.04);border-radius:10px;border:1px solid rgba(255,255,255,0.06);}
.sb-av{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#fff;flex-shrink:0;}
.sb-uname{font-size:12px;font-weight:600;color:#fff;}
.sb-urole{font-size:11px;color:rgba(255,255,255,0.3);text-transform:capitalize;}
.main{margin-left:240px;flex:1;display:flex;flex-direction:column;}
.topbar{background:rgba(255,255,255,0.92);backdrop-filter:blur(12px);border-bottom:1px solid var(--border);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.tb-left h1{font-size:19px;font-weight:700;}
.tb-left p{font-size:12px;color:var(--muted);margin-top:1px;}
.tb-right{display:flex;gap:10px;align-items:center;}
.live-badge{display:flex;align-items:center;gap:6px;padding:7px 13px;background:rgba(34,197,94,0.08);border:1px solid rgba(34,197,94,0.2);border-radius:8px;font-size:12px;font-weight:600;color:#15803d;}
.live-dot{width:6px;height:6px;border-radius:50%;background:#22C55E;animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{box-shadow:0 0 0 0 rgba(34,197,94,0.4);}50%{box-shadow:0 0 0 6px rgba(34,197,94,0);}}
.btn-logout{background:#FEE2E2;color:#dc2626;border:1.5px solid #fca5a5;padding:8px 16px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all 0.15s;}
.btn-logout:hover{background:#dc2626;color:#fff;}
.content{padding:24px 28px;flex:1;}
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:20px;}
.stat-card{background:var(--surface);border-radius:14px;padding:20px;border:1px solid var(--border);box-shadow:var(--shadow);display:flex;flex-direction:column;gap:12px;transition:all 0.2s;}
.stat-card:hover{transform:translateY(-2px);box-shadow:var(--shadow-md);}
.stat-hdr{display:flex;align-items:center;justify-content:space-between;}
.stat-lbl{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;}
.stat-ico{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:17px;}
.stat-val{font-size:30px;font-weight:700;color:var(--text);line-height:1;}
.badge{display:inline-flex;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px;}
.bg{background:var(--green-light);color:#15803d;}
.ba{background:var(--amber-light);color:#b45309;}
.bb{background:var(--accent-light);color:var(--accent);}
.br{background:var(--red-light);color:#dc2626;}
.section-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px;}
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:20px;}
.btn-sm{display:inline-flex;align-items:center;gap:5px;padding:7px 13px;border-radius:7px;font-size:12px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--text);text-decoration:none;transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.btn-sm:hover{border-color:var(--accent);color:var(--accent);}
.slots-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:8px;}
.slot{border-radius:9px;padding:10px 5px;text-align:center;border:2px solid;transition:all 0.15s;}
.slot-name{font-size:12px;font-weight:700;margin-bottom:3px;}
.slot-status{font-size:9px;font-weight:600;text-transform:uppercase;opacity:0.8;}
.slot.free{background:var(--green-light);border-color:#86efac;color:#15803d;}
.slot.occupied{background:var(--red-light);border-color:#fca5a5;color:#b91c1c;}
.slot.reserved{background:var(--amber-light);border-color:#fcd34d;color:#92400e;}
.legend{display:flex;gap:14px;padding:11px 20px;border-top:1px solid var(--border);background:#fafbff;}
.leg{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--muted);}
.leg-dot{width:9px;height:9px;border-radius:50%;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:11px 14px;vertical-align:middle;}
.vtag{font-size:11px;font-weight:700;background:var(--navy);color:#fff;padding:3px 8px;border-radius:5px;}
.pill{display:inline-flex;padding:3px 8px;border-radius:20px;font-size:11px;font-weight:600;}
.pc{background:var(--accent-light);color:var(--accent);}
.pb{background:var(--amber-light);color:#92400e;}
.pv{background:var(--green-light);color:#15803d;}
.uid{font-size:12px;color:var(--muted);font-weight:600;}
.del-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}
.edit-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid #fcd34d;background:#FEF3C7;color:#92400e;text-decoration:none;display:inline-flex;transition:all 0.15s;}
.edit-btn:hover{background:#F59E0B;color:#fff;border-color:#F59E0B;}
.alert-msg{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;}
.alert-s{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
</style>
</head>
<body>

<aside class="sidebar">
  <div class="sb-logo"><div class="sb-brand"><div class="sb-icon">P</div><div class="sb-name">ParkSmart</div></div></div>
  <div class="sb-sec">
    <div class="sb-lbl">Main</div>
    <a class="sb-item active" href="home.jsp"><div class="sb-ico">⬛</div>Dashboard</a>
    <a class="sb-item" href="register"><div class="sb-ico">👤</div>User Registration</a>
    <a class="sb-item" href="slots"><div class="sb-ico">🅿️</div>Parking Slots</a>
    <a class="sb-item" href="reservations"><div class="sb-ico">📅</div>Reservations</a>
  </div>
  <div class="sb-div"></div>
  <div class="sb-sec">
    <div class="sb-lbl">System</div>
    <a class="sb-item" href="security.jsp"><div class="sb-ico">🔐</div>Security</a>
    <a class="sb-item" href="history"><div class="sb-ico">📋</div>Parking History</a>
    <a class="sb-item" href="billing"><div class="sb-ico">💳</div>Billing</a>
    <a class="sb-item" href="feedback.jsp"><div class="sb-ico">💬</div>Feedback</a>
    <a class="sb-item" href="reports.jsp"><div class="sb-ico">📊</div>Reports</a>
    <% if (isAdmin) { %><a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a><% } %>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= avatarLetter %></div>
      <div><div class="sb-uname"><%= sessionName %></div><div class="sb-urole"><%= sessionRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Dashboard</h1><p>ParkSmart — Real-time overview</p></div>
    <div class="tb-right">
      <div class="live-badge"><div class="live-dot"></div>System Live</div>
      <a href="logout" class="btn-logout">⏏ Logout</a>
    </div>
  </header>

  <div class="content">
    <% if ("true".equals(request.getParameter("success"))) { %>
    <div class="alert-msg alert-s">✅ Operation completed successfully!</div>
    <% } %>

    <!-- STAT CARDS — all read live from DB -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-hdr"><span class="stat-lbl">Total Users</span><div class="stat-ico" style="background:#eef2ff;">👥</div></div>
        <div class="stat-val"><%= homeUsers.size() %></div>
        <span class="badge bb">Registered</span>
      </div>
      <div class="stat-card">
        <div class="stat-hdr"><span class="stat-lbl">Slots Available</span><div class="stat-ico" style="background:#DCFCE7;">🟢</div></div>
        <div class="stat-val"><%= freeSlots %></div>
        <div style="display:flex;gap:7px;align-items:center;">
          <span class="badge ba"><%= occupiedSlots %> occupied</span>
          <span style="font-size:11px;color:var(--muted);">of <%= homeSlots.size() %></span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-hdr"><span class="stat-lbl">Vehicles Parked</span><div class="stat-ico" style="background:#FEE2E2;">🚗</div></div>
        <div class="stat-val"><%= occupiedSlots %></div>
        <span class="badge br">Active now</span>
      </div>
      <div class="stat-card">
        <div class="stat-hdr"><span class="stat-lbl">Reserved Slots</span><div class="stat-ico" style="background:#FEF3C7;">📅</div></div>
        <div class="stat-val"><%= reservedSlots %></div>
        <span class="badge ba">Reserved</span>
      </div>
    </div>

    <!-- SLOT GRID + QUICK ACTIONS -->
    <div class="section-grid">
      <div class="card">
        <div class="card-hdr">
          <div class="card-title"><div class="card-ico">🅿️</div>Parking Slot Overview</div>
          <div style="display:flex;gap:8px;align-items:center;">
            <span class="badge bg"><%= freeSlots %> free</span>
            <a href="slots" class="btn-sm">View All →</a>
          </div>
        </div>
        <div class="card-body">
          <div class="slots-grid">
            <% for (ParkingSlot slot : homeSlots) {
              String cls = "free", lbl = "Free";
              if ("Occupied".equals(slot.getStatus()))  { cls = "occupied"; lbl = "Occupied"; }
              else if ("Reserved".equals(slot.getStatus())) { cls = "reserved"; lbl = "Reserved"; }
            %>
            <div class="slot <%= cls %>">
              <div class="slot-name"><%= slot.getSlotName() != null ? slot.getSlotName() : "S"+slot.getSlotId() %></div>
              <div class="slot-status"><%= lbl %></div>
            </div>
            <% } %>
            <% if (homeSlots.isEmpty()) { %>
            <div style="grid-column:1/-1;text-align:center;color:var(--muted);padding:20px;font-size:13px;">No slots. <a href="add-slot.jsp" style="color:var(--accent);">Add slots →</a></div>
            <% } %>
          </div>
        </div>
        <div class="legend">
          <div class="leg"><div class="leg-dot" style="background:#22C55E;"></div>Available</div>
          <div class="leg"><div class="leg-dot" style="background:#EF4444;"></div>Occupied</div>
          <div class="leg"><div class="leg-dot" style="background:#F59E0B;"></div>Reserved</div>
        </div>
      </div>

      <!-- QUICK LINKS PANEL -->
      <div class="card">
        <div class="card-hdr"><div class="card-title"><div class="card-ico">⚡</div>Quick Actions</div></div>
        <div class="card-body">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
            <a href="register" style="background:#eef2ff;border-radius:10px;padding:16px;text-decoration:none;display:flex;flex-direction:column;gap:6px;transition:all 0.15s;" onmouseover="this.style.background='#e0e7ff'" onmouseout="this.style.background='#eef2ff'">
              <span style="font-size:22px;">👤</span>
              <span style="font-size:13px;font-weight:600;color:#0f172a;">Register User</span>
              <span style="font-size:11px;color:#64748b;">Add new user & vehicle</span>
            </a>
            <a href="slots" style="background:#DCFCE7;border-radius:10px;padding:16px;text-decoration:none;display:flex;flex-direction:column;gap:6px;transition:all 0.15s;" onmouseover="this.style.background='#bbf7d0'" onmouseout="this.style.background='#DCFCE7'">
              <span style="font-size:22px;">🅿️</span>
              <span style="font-size:13px;font-weight:600;color:#0f172a;">Manage Slots</span>
              <span style="font-size:11px;color:#64748b;">Change slot status</span>
            </a>
            <a href="security.jsp" style="background:#FEE2E2;border-radius:10px;padding:16px;text-decoration:none;display:flex;flex-direction:column;gap:6px;transition:all 0.15s;" onmouseover="this.style.background='#fecaca'" onmouseout="this.style.background='#FEE2E2'">
              <span style="font-size:22px;">🔐</span>
              <span style="font-size:13px;font-weight:600;color:#0f172a;">Security</span>
              <span style="font-size:11px;color:#64748b;">Vehicle entry & exit</span>
            </a>
            <a href="billing" style="background:#FEF3C7;border-radius:10px;padding:16px;text-decoration:none;display:flex;flex-direction:column;gap:6px;transition:all 0.15s;" onmouseover="this.style.background='#fde68a'" onmouseout="this.style.background='#FEF3C7'">
              <span style="font-size:22px;">💳</span>
              <span style="font-size:13px;font-weight:600;color:#0f172a;">Billing</span>
              <span style="font-size:11px;color:#64748b;">Process payment</span>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- USERS TABLE — admin only, with Edit + Delete -->
    <% if (isAdmin) { %>
    <div class="card">
      <div class="card-hdr">
        <div class="card-title"><div class="card-ico">📋</div>Registered Users & Vehicles</div>
        <a href="register" class="btn-sm">+ Add User</a>
      </div>
      <table>
        <thead><tr><th>ID</th><th>Name</th><th>Contact</th><th>Vehicle No.</th><th>Type</th><th>Role</th><th>Actions</th></tr></thead>
        <tbody>
          <% for (User u : homeUsers) {
             String vType = u.getVehicleType() != null ? u.getVehicleType() : "—";
             String pCls = "pc";
             if ("Motorbike".equals(vType)) pCls = "pb";
             else if ("Van".equals(vType)) pCls = "pv";
          %>
          <tr>
            <td><span class="uid">#<%= String.format("%03d", u.getUserId()) %></span></td>
            <td><strong><%= u.getName() %></strong></td>
            <td style="font-size:12px;color:var(--muted);"><%= u.getContact() %></td>
            <td><span class="vtag"><%= u.getVehicleNo() != null && !u.getVehicleNo().isEmpty() ? u.getVehicleNo() : "—" %></span></td>
            <td><span class="pill <%= pCls %>"><%= vType %></span></td>
            <td><span class="badge <%= "admin".equals(u.getRole()) ? "bb" : "bg" %>"><%= u.getRole() %></span></td>
            <td style="display:flex;gap:6px;">
              <a href="editUser?userId=<%= u.getUserId() %>" class="edit-btn">Edit</a>
              <form action="deleteUser" method="post" style="display:inline;">
                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                <button type="submit" class="del-btn" onclick="return confirm('Delete user?')">Delete</button>
              </form>
            </td>
          </tr>
          <% } %>
          <% if (homeUsers.isEmpty()) { %>
          <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:24px;">No users yet.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
    <% } %>

  </div>
</div>
</body>
</html>
