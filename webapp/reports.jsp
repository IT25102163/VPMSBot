<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  String repName = (String) session.getAttribute("name");
  String repRole = (String) session.getAttribute("role");
  if (repName == null) repName = "User";
  if (repRole == null) repRole = "user";

  UserDAO repUserDAO = new UserDAO();
  List<User> repUsers = new ArrayList<>();
  try { repUsers = repUserDAO.getAllUsers(); } catch(Exception e) {}

  ParkingSlotDAO repSlotDAO = new ParkingSlotDAO();
  int repFreeSlots = 0;
  int repTotalSlots = 0;
  try {
    repFreeSlots = repSlotDAO.countFreeSlots();
    repTotalSlots = repSlotDAO.getAllSlots().size();
  } catch(Exception e) {}

  ParkingLotDAO repBillingDAO = new ParkingLotDAO();
  List<Billing> repBillings = new ArrayList<>();
  try { repBillings = repBillingDAO.getBillings(); } catch(Exception e) {}

  double totalRevenue = 0;
  for (Billing b : repBillings) totalRevenue += b.getAmount();

  // Count without lambdas
  int adminCount = 0;
  int userCount = 0;
  int withVehicle = 0;
  for (User u : repUsers) {
    if ("admin".equals(u.getRole())) adminCount++;
    else userCount++;
    if (u.getVehicleNo() != null && !u.getVehicleNo().isEmpty()) withVehicle++;
  }
  int paidCount = 0;
  int pendingCount = 0;
  for (Billing b : repBillings) {
    if ("paid".equals(b.getStatus())) paidCount++;
    else pendingCount++;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>Park Smart — Reports</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet"/>
<style>
:root{--bg:#F0F4FF;--surface:#FFFFFF;--navy:#1A2340;--accent:#4F6EF7;--accent-light:#EEF2FF;--green:#22C55E;--green-light:#DCFCE7;--amber:#F59E0B;--amber-light:#FEF3C7;--red:#EF4444;--red-light:#FEE2E2;--text:#1A2340;--text-muted:#6B7A99;--border:#E2E8F8;--shadow:0 2px 12px rgba(26,35,64,0.06);}
*{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;}
.sidebar{width:256px;background:linear-gradient(180deg,#1A2340 0%,#1e2d4f 100%);min-height:100vh;display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:100;}
.sidebar-logo{padding:28px 24px 22px;border-bottom:1px solid rgba(255,255,255,0.06);}
.logo-wrap{display:flex;align-items:center;gap:12px;}
.logo-box{width:40px;height:40px;background:linear-gradient(135deg,#4F6EF7,#7C3AED);border-radius:11px;display:flex;align-items:center;justify-content:center;font-family:'Space Mono',monospace;font-size:17px;font-weight:700;color:#fff;}
.logo-name{font-family:'Space Mono',monospace;font-size:17px;font-weight:700;color:#fff;}
.sidebar-section{padding:20px 16px 4px;}
.sidebar-label{font-size:10px;font-weight:700;letter-spacing:1.5px;color:rgba(255,255,255,0.25);text-transform:uppercase;padding:0 10px;margin-bottom:6px;}
.nav-item{display:flex;align-items:center;gap:11px;padding:10px 12px;border-radius:10px;color:rgba(255,255,255,0.5);font-size:13.5px;font-weight:500;transition:all 0.18s;margin-bottom:2px;text-decoration:none;}
.nav-item:hover{background:rgba(255,255,255,0.07);color:rgba(255,255,255,0.85);}
.nav-item.active{background:linear-gradient(135deg,rgba(79,110,247,0.3),rgba(124,58,237,0.2));color:#fff;border:1px solid rgba(79,110,247,0.3);}
.nav-icon-wrap{width:32px;height:32px;border-radius:8px;background:rgba(255,255,255,0.07);display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;}
.nav-item.active .nav-icon-wrap{background:linear-gradient(135deg,#4F6EF7,#7C3AED);}
.sidebar-divider{height:1px;background:rgba(255,255,255,0.06);margin:8px 16px;}
.sidebar-footer{margin-top:auto;padding:16px;border-top:1px solid rgba(255,255,255,0.06);}
.user-card{display:flex;align-items:center;gap:10px;padding:11px 13px;background:rgba(255,255,255,0.05);border-radius:11px;border:1px solid rgba(255,255,255,0.06);}
.user-avatar{width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,#4F6EF7,#7C3AED);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;color:#fff;flex-shrink:0;}
.user-name{font-size:13px;font-weight:600;color:#fff;}
.user-role{font-size:11px;color:rgba(255,255,255,0.35);}
.main{margin-left:256px;flex:1;min-height:100vh;display:flex;flex-direction:column;}
.topbar{background:rgba(255,255,255,0.9);backdrop-filter:blur(10px);border-bottom:1px solid var(--border);padding:16px 32px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.topbar-left h1{font-size:20px;font-weight:700;}
.topbar-left p{font-size:13px;color:var(--text-muted);margin-top:1px;}
.content{padding:28px 32px;flex:1;}
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px;}
.stat-card{background:var(--surface);border-radius:16px;padding:22px;border:1px solid var(--border);box-shadow:var(--shadow);display:flex;flex-direction:column;gap:12px;}
.stat-label{font-size:11px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.8px;}
.stat-value{font-family:'Space Mono',monospace;font-size:28px;font-weight:700;}
.stat-badge{display:inline-flex;font-size:11px;font-weight:600;padding:4px 10px;border-radius:20px;}
.badge-green{background:var(--green-light);color:#15803d;}
.badge-blue{background:var(--accent-light);color:var(--accent);}
.badge-amber{background:var(--amber-light);color:#b45309;}
.section-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.card{background:var(--surface);border-radius:16px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-header{padding:18px 22px 14px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:9px;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:9px;}
.card-icon{width:30px;height:30px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:14px;background:var(--accent-light);}
.card-body{padding:20px 22px;}
.report-item{display:flex;align-items:center;justify-content:space-between;padding:12px 0;border-bottom:1px solid var(--border);font-size:13px;}
.report-item:last-child{border-bottom:none;}
.report-label{color:var(--text-muted);}
.report-value{font-family:'Space Mono',monospace;font-weight:700;color:var(--text);}
.btn{display:inline-flex;align-items:center;gap:7px;padding:9px 16px;border-radius:9px;font-size:13px;font-weight:600;cursor:pointer;border:none;font-family:'DM Sans',sans-serif;text-decoration:none;}
.btn-outline{background:transparent;border:1.5px solid var(--border);color:var(--text);}
</style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="logo-wrap">
      <div class="logo-box">P</div>
      <div class="logo-name">Park Smart</div>
    </div>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Main</div>
    <a class="nav-item" href="home.jsp"><div class="nav-icon-wrap">⬛</div>Dashboard</a>
    <a class="nav-item" href="register"><div class="nav-icon-wrap">👤</div>User Registration</a>
    <a class="nav-item" href="slots"><div class="nav-icon-wrap">🅿️</div>Parking Slots</a>
    <a class="nav-item" href="reservations"><div class="nav-icon-wrap">📅</div>Reservations</a>
  </div>
  <div class="sidebar-divider"></div>
  <div class="sidebar-section">
    <div class="sidebar-label">System</div>
    <a class="nav-item" href="history"><div class="nav-icon-wrap">📋</div>Parking History</a>
    <a class="nav-item" href="billing"><div class="nav-icon-wrap">💳</div>Billing</a>
    <a class="nav-item" href="feedback.jsp"><div class="nav-icon-wrap">💬</div>Feedback</a>
    <a class="nav-item active" href="reports.jsp"><div class="nav-icon-wrap">📊</div>Reports</a>
    <a class="nav-item" href="admin"><div class="nav-icon-wrap">⚙️</div>Admin Panel</a>
  </div>
  <div class="sidebar-footer">
    <div class="user-card">
      <div class="user-avatar"><%= repName.substring(0,1).toUpperCase() %></div>
      <div><div class="user-name"><%= repName %></div><div class="user-role"><%= repRole %></div></div>
    </div>
  </div>
</aside>
<div class="main">
  <header class="topbar">
    <div class="topbar-left">
      <h1>Reports</h1>
      <p>System overview and summary statistics</p>
    </div>
    <a href="history" class="btn btn-outline">⬇ View Full History</a>
  </header>
  <div class="content">
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-label">Total Users</div>
        <div class="stat-value"><%= repUsers.size() %></div>
        <span class="stat-badge badge-green">Registered</span>
      </div>
      <div class="stat-card">
        <div class="stat-label">Slots Available</div>
        <div class="stat-value" style="color:#22C55E;"><%= repFreeSlots %></div>
        <span class="stat-badge badge-green">of <%= repTotalSlots %> total</span>
      </div>
      <div class="stat-card">
        <div class="stat-label">Total Payments</div>
        <div class="stat-value"><%= repBillings.size() %></div>
        <span class="stat-badge badge-blue">Transactions</span>
      </div>
      <div class="stat-card">
        <div class="stat-label">Total Revenue</div>
        <div class="stat-value" style="font-size:18px;margin-top:4px;">Rs.<%= String.format("%.0f", totalRevenue) %></div>
        <span class="stat-badge badge-green">All time</span>
      </div>
    </div>
    <div class="section-grid">
      <div class="card">
        <div class="card-header">
          <div class="card-title"><div class="card-icon">👥</div>User Summary</div>
        </div>
        <div class="card-body">
          <div class="report-item"><span class="report-label">Total registered users</span><span class="report-value"><%= repUsers.size() %></span></div>
          <div class="report-item"><span class="report-label">Admin users</span><span class="report-value"><%= adminCount %></span></div>
          <div class="report-item"><span class="report-label">Regular users</span><span class="report-value"><%= userCount %></span></div>
          <div class="report-item"><span class="report-label">Users with vehicles</span><span class="report-value"><%= withVehicle %></span></div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title"><div class="card-icon">💳</div>Billing Summary</div>
        </div>
        <div class="card-body">
          <div class="report-item"><span class="report-label">Total transactions</span><span class="report-value"><%= repBillings.size() %></span></div>
          <div class="report-item"><span class="report-label">Total revenue</span><span class="report-value">Rs.<%= String.format("%.2f", totalRevenue) %></span></div>
          <div class="report-item"><span class="report-label">Paid invoices</span><span class="report-value"><%= paidCount %></span></div>
          <div class="report-item"><span class="report-label">Pending invoices</span><span class="report-value"><%= pendingCount %></span></div>
        </div>
      </div>
    </div>
  </div>
</div>

</body>
</html>
