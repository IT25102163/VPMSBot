<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("slots"); return; }
  String sdName = (String) session.getAttribute("name");
  if (sdName == null) sdName = "Admin";

  String slotId     = request.getParameter("id");
  String slotName   = request.getParameter("name");
  String slotStatus = request.getParameter("status");

  if (slotId == null || slotId.isEmpty()) { response.sendRedirect("slots"); return; }

  // Colour based on status
  String bgColor, borderColor, textColor, statusLabel;
  if ("Occupied".equals(slotStatus)) {
    bgColor = "#FEE2E2"; borderColor = "#fca5a5"; textColor = "#b91c1c"; statusLabel = "Occupied";
  } else if ("Reserved".equals(slotStatus)) {
    bgColor = "#FEF3C7"; borderColor = "#fcd34d"; textColor = "#92400e"; statusLabel = "Reserved";
  } else {
    bgColor = "#DCFCE7"; borderColor = "#86efac"; textColor = "#15803d"; statusLabel = "Available";
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Slot <%= slotName %></title>
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
.btn-back{background:transparent;border:1.5px solid var(--border);color:var(--text);padding:8px 16px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;}
.btn-back:hover{background:var(--bg);}
.btn-logout{background:#FEE2E2;color:#dc2626;border:1.5px solid #fca5a5;padding:8px 16px;border-radius:8px;font-size:13px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;}
.content{padding:40px 28px;flex:1;display:flex;align-items:flex-start;justify-content:center;}
.detail-wrap{width:100%;max-width:480px;}

/* BIG SLOT DISPLAY */
.slot-display{border-radius:20px;padding:40px 30px;text-align:center;border:3px solid;margin-bottom:28px;background:<%= bgColor %>;border-color:<%= borderColor %>;}
.slot-big-name{font-size:56px;font-weight:800;color:<%= textColor %>;letter-spacing:-2px;margin-bottom:8px;}
.slot-big-status{font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:<%= textColor %>;opacity:0.75;margin-bottom:4px;}
.slot-id{font-size:12px;color:<%= textColor %>;opacity:0.5;}

/* ACTION BUTTONS */
.actions{display:flex;flex-direction:column;gap:12px;}
.action-btn{width:100%;padding:16px;border-radius:12px;font-size:15px;font-weight:700;cursor:pointer;border:none;font-family:'DM Sans',sans-serif;display:flex;align-items:center;justify-content:center;gap:10px;transition:all 0.2s;}
.action-btn:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(0,0,0,0.15);}
.btn-free{background:linear-gradient(135deg,#22C55E,#16a34a);color:#fff;}
.btn-occupy{background:linear-gradient(135deg,#EF4444,#dc2626);color:#fff;}
.btn-reserve{background:linear-gradient(135deg,#F59E0B,#d97706);color:#fff;}
.btn-delete{background:linear-gradient(135deg,#0f172a,#1e293b);color:#fff;}
.divider{height:1px;background:var(--border);margin:4px 0;}
.back-link{display:flex;align-items:center;justify-content:center;margin-top:20px;}
.back-link a{color:var(--muted);font-size:13px;text-decoration:none;display:flex;align-items:center;gap:6px;}
.back-link a:hover{color:var(--accent);}
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
      <div class="sb-av"><%= sdName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= sdName %></div><div class="sb-urole">Admin</div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left">
      <h1>Manage Slot <%= slotName %></h1>
      <p>Change status or delete this parking slot</p>
    </div>
    <div style="display:flex;gap:10px;">
      <a href="slots" class="btn-back">← Back to Slots</a>
      <a href="#" onclick="if(confirm('Are you sure you want to logout?'))window.location.href='logout'" class="btn-logout">⏏ Logout</a>
    </div>
  </header>

  <div class="content">
    <div class="detail-wrap">

      <!-- BIG SLOT BOX -->
      <div class="slot-display">
        <div class="slot-big-name"><%= slotName %></div>
        <div class="slot-big-status"><%= statusLabel %></div>
        <div class="slot-id">Slot ID: #<%= slotId %></div>
      </div>

      <!-- ACTION BUTTONS -->
      <div class="actions">

        <% if (!"Available".equals(slotStatus)) { %>
        <form action="slots" method="post">
          <input type="hidden" name="action" value="update"/>
          <input type="hidden" name="id"     value="<%= slotId %>"/>
          <input type="hidden" name="status" value="Available"/>
          <button type="submit" class="action-btn btn-free">✓ Mark as Available (Free)</button>
        </form>
        <% } %>

        <% if (!"Occupied".equals(slotStatus)) { %>
        <form action="slots" method="post">
          <input type="hidden" name="action" value="update"/>
          <input type="hidden" name="id"     value="<%= slotId %>"/>
          <input type="hidden" name="status" value="Occupied"/>
          <button type="submit" class="action-btn btn-occupy">● Mark as Occupied</button>
        </form>
        <% } %>

        <% if (!"Reserved".equals(slotStatus)) { %>
        <form action="slots" method="post">
          <input type="hidden" name="action" value="update"/>
          <input type="hidden" name="id"     value="<%= slotId %>"/>
          <input type="hidden" name="status" value="Reserved"/>
          <button type="submit" class="action-btn btn-reserve">◆ Mark as Reserved</button>
        </form>
        <% } %>

        <div class="divider"></div>

        <form action="slots" method="post"
              onsubmit="return confirm('Delete slot <%= slotName %> permanently? This cannot be undone.')">
          <input type="hidden" name="action" value="delete"/>
          <input type="hidden" name="id"     value="<%= slotId %>"/>
          <button type="submit" class="action-btn btn-delete">✕ Delete This Slot</button>
        </form>

      </div>

      <div class="back-link">
        <a href="slots">← Back to all parking slots</a>
      </div>

    </div>
  </div>
</div>
</body>
</html>
