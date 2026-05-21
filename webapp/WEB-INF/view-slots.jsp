<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String vsName = (String) session.getAttribute("name");
  String vsRole = (String) session.getAttribute("role");
  if (vsName == null) vsName = "User";
  if (vsRole == null) vsRole = "user";
  boolean isAdmin = "admin".equals(vsRole);

  List<ParkingSlot> allSlots = (List<ParkingSlot>) request.getAttribute("slots");
  if (allSlots == null) allSlots = new ArrayList<>();

  int freeCount = 0, occupiedCount = 0, reservedCount = 0;
  for (ParkingSlot s : allSlots) {
    if ("Available".equals(s.getStatus())) freeCount++;
    else if ("Occupied".equals(s.getStatus())) occupiedCount++;
    else if ("Reserved".equals(s.getStatus())) reservedCount++;
  }

  // Top 3 free slots to recommend to users
  List<ParkingSlot> recommended = new ArrayList<>();
  for (ParkingSlot s : allSlots) {
    if ("Available".equals(s.getStatus()) && recommended.size() < 3)
      recommended.add(s);
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Parking Slots</title>
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
.topbar-right{display:flex;gap:10px;align-items:center;}
.btn-logout{background:#FEE2E2;color:#dc2626;border:1.5px solid #fca5a5;padding:8px 16px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;}
.btn-logout:hover{background:#dc2626;color:#fff;}
.btn-add{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;padding:8px 16px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;}
.content{padding:24px 28px;flex:1;}
.stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:20px;}
.stat-card{background:var(--surface);border-radius:14px;padding:18px;border:1px solid var(--border);box-shadow:var(--shadow);display:flex;flex-direction:column;gap:10px;}
.stat-lbl{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;}
.stat-val{font-size:28px;font-weight:700;}
.badge{display:inline-flex;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px;}
.bg{background:var(--green-light);color:#15803d;}
.br{background:var(--red-light);color:#dc2626;}
.ba{background:var(--amber-light);color:#b45309;}
/* RECOMMENDED */
.recommend-card{background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(34,197,94,0.04));border:1.5px solid rgba(99,102,241,0.2);border-radius:14px;padding:20px;margin-bottom:20px;}
.recommend-title{font-size:14px;font-weight:700;margin-bottom:4px;display:flex;align-items:center;gap:8px;}
.recommend-sub{font-size:12px;color:var(--muted);margin-bottom:16px;}
.recommend-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;}
.rec-slot{background:#fff;border:2px solid #22C55E;border-radius:12px;padding:16px;text-align:center;position:relative;}
.rec-badge{position:absolute;top:-10px;left:50%;transform:translateX(-50%);background:linear-gradient(135deg,#22C55E,#16a34a);color:#fff;font-size:10px;font-weight:700;padding:3px 10px;border-radius:20px;white-space:nowrap;}
.rec-name{font-size:18px;font-weight:800;color:var(--navy);margin:8px 0 4px;}
.rec-status{font-size:11px;color:#15803d;font-weight:600;margin-bottom:12px;}
.btn-reserve{background:linear-gradient(135deg,#22C55E,#16a34a);color:#fff;border:none;padding:8px 16px;border-radius:7px;font-size:12px;font-weight:700;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;text-decoration:none;display:block;text-align:center;}
.no-free{text-align:center;padding:24px;color:var(--muted);font-size:13px;}
/* SLOT GRID */
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:20px;}
.slots-grid{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;}

/* CLEAN SLOT BOX — just colour + name + status */
.slot-box{border-radius:11px;padding:16px 8px;text-align:center;border:2px solid;transition:all 0.2s;cursor:pointer;text-decoration:none;display:block;}
.slot-box:hover{transform:translateY(-3px);box-shadow:0 6px 16px rgba(0,0,0,0.12);}
.slot-name{font-size:14px;font-weight:800;margin-bottom:4px;}
.slot-status{font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:0.6px;opacity:0.75;}
.slot-box.free{background:var(--green-light);border-color:#86efac;color:#15803d;}
.slot-box.occupied{background:var(--red-light);border-color:#fca5a5;color:#b91c1c;}
.slot-box.reserved{background:var(--amber-light);border-color:#fcd34d;color:#92400e;}
.slot-box.highlighted{box-shadow:0 0 0 3px rgba(99,102,241,0.35)!important;border-color:#6366f1!important;}

/* User reserve button */
.slot-reserve-btn{font-size:9px;font-weight:700;padding:4px;border-radius:4px;cursor:pointer;border:none;font-family:'DM Sans',sans-serif;width:100%;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;margin-top:6px;text-decoration:none;display:block;text-align:center;}

.legend{display:flex;gap:16px;padding:12px 20px;border-top:1px solid var(--border);background:#fafbff;}
.leg{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--muted);font-weight:500;}
.leg-dot{width:9px;height:9px;border-radius:50%;}
.admin-hint{background:#eef2ff;border:1px solid #c7d2fe;border-radius:9px;padding:11px 14px;font-size:12px;color:#4338ca;margin-bottom:16px;}
</style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-logo"><div class="sb-brand"><div class="sb-icon">P</div><div class="sb-name">ParkSmart</div></div></div>
  <div class="sb-sec">
    <div class="sb-lbl">Main</div>
    <a class="sb-item" href="home.jsp"><div class="sb-ico">⬛</div>Dashboard</a>
    <a class="sb-item" href="register"><div class="sb-ico">👤</div>User Registration</a>
    <a class="sb-item active" href="slots"><div class="sb-ico">🅿️</div>Parking Slots</a>
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
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= vsName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= vsName %></div><div class="sb-urole"><%= vsRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left">
      <h1>Parking Slots</h1>
      <p>Real-time slot availability — <%= allSlots.size() %> slots total</p>
    </div>
    <div class="topbar-right">
      <% if (isAdmin) { %>
      <a href="add-slot.jsp" class="btn-add">+ Add Slot</a>
      <% } %>
      <a href="#" onclick="if(confirm('Are you sure you want to logout?'))window.location.href='logout'" class="btn-logout">⏏ Logout</a>
    </div>
  </header>

  <div class="content">
    <!-- STATS -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-lbl">Available</div>
        <div class="stat-val" style="color:#22C55E;"><%= freeCount %></div>
        <span class="badge bg">Free slots</span>
      </div>
      <div class="stat-card">
        <div class="stat-lbl">Occupied</div>
        <div class="stat-val" style="color:#EF4444;"><%= occupiedCount %></div>
        <span class="badge br">In use</span>
      </div>
      <div class="stat-card">
        <div class="stat-lbl">Reserved</div>
        <div class="stat-val" style="color:#F59E0B;"><%= reservedCount %></div>
        <span class="badge ba">Reserved</span>
      </div>
    </div>

    <!-- RECOMMENDED — users only -->
    <% if (!isAdmin && !recommended.isEmpty()) { %>
    <div class="recommend-card">
      <div class="recommend-title">⭐ Recommended Slots For You</div>
      <div class="recommend-sub">These are the closest available parking slots right now</div>
      <div class="recommend-grid">
        <% String[] labels = {"🥇 Best Choice", "🥈 2nd Closest", "🥉 3rd Option"};
           for (int i = 0; i < recommended.size(); i++) {
          ParkingSlot rs = recommended.get(i); %>
        <div class="rec-slot">
          <div class="rec-badge"><%= labels[i] %></div>
          <div class="rec-name"><%= rs.getSlotName() != null ? rs.getSlotName() : "S"+rs.getSlotId() %></div>
          <div class="rec-status">✓ Available Now</div>
          <a href="reservations?slotId=<%= rs.getSlotId() %>" class="btn-reserve">Reserve This Slot →</a>
        </div>
        <% } %>
      </div>
    </div>
    <% } %>

    <!-- SLOT GRID -->
    <div class="card">
      <div class="card-hdr">
        <div class="card-title"><div class="card-ico">🅿️</div>All Parking Slots</div>
        <span class="badge bg"><%= freeCount %> available</span>
      </div>
      <div class="card-body">
        <% if (isAdmin) { %>
        <div class="admin-hint">💡 Click on any slot to manage it — change status or delete.</div>
        <% } %>
        <div class="slots-grid">
          <% for (ParkingSlot slot : allSlots) {
            String cls = "free", lbl = "Available";
            if ("Occupied".equals(slot.getStatus()))  { cls = "occupied"; lbl = "Occupied"; }
            else if ("Reserved".equals(slot.getStatus())) { cls = "reserved"; lbl = "Reserved"; }
            String sName = slot.getSlotName() != null ? slot.getSlotName() : "S" + slot.getSlotId();
            boolean isRec = recommended.contains(slot);
          %>
          <% if (isAdmin) { %>
          <!-- Admin: clicking goes to slot detail page -->
          <a href="slot-detail.jsp?id=<%= slot.getSlotId() %>&name=<%= sName %>&status=<%= slot.getStatus() %>"
             class="slot-box <%= cls %>">
            <div class="slot-name"><%= sName %></div>
            <div class="slot-status"><%= lbl %></div>
          </a>
          <% } else { %>
          <!-- User: free slots show reserve button, others just show status -->
          <div class="slot-box <%= cls %> <%= isRec ? "highlighted" : "" %>">
            <div class="slot-name"><%= sName %></div>
            <div class="slot-status"><%= lbl %></div>
            <% if ("Available".equals(slot.getStatus())) { %>
            <a href="reservations?slotId=<%= slot.getSlotId() %>" class="slot-reserve-btn">Reserve →</a>
            <% } %>
          </div>
          <% } %>
          <% } %>
          <% if (allSlots.isEmpty()) { %>
          <div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--muted);font-size:13px;">
            No slots yet. <% if (isAdmin) { %><a href="add-slot.jsp" style="color:var(--accent);">Add slots →</a><% } %>
          </div>
          <% } %>
        </div>
      </div>
      <div class="legend">
        <div class="leg"><div class="leg-dot" style="background:#22C55E;"></div>Available</div>
        <div class="leg"><div class="leg-dot" style="background:#EF4444;"></div>Occupied</div>
        <div class="leg"><div class="leg-dot" style="background:#F59E0B;"></div>Reserved</div>
        <% if (!isAdmin) { %>
        <div class="leg"><div class="leg-dot" style="background:#6366f1;"></div>Recommended</div>
        <% } else { %>
        <div class="leg" style="color:#6366f1;font-weight:600;">👆 Click any slot to manage it</div>
        <% } %>
      </div>
    </div>
  </div>
</div>
</body>
</html>
