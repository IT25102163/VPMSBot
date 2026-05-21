<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Park Smart</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#F4F6FB;--surface:#FFFFFF;--surface2:#EEF1F8;--navy:#1A2340;--accent:#4F6EF7;--accent-light:#E8ECFF;--green:#22C55E;--green-light:#DCFCE7;--red:#EF4444;--red-light:#FEE2E2;--amber:#F59E0B;--amber-light:#FEF3C7;--text:#1A2340;--text-muted:#6B7A99;--border:#DDE3F0;--shadow:0 2px 16px rgba(26,35,64,0.07);--shadow-md:0 6px 32px rgba(26,35,64,0.12);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;}
    .sidebar{width:240px;background:var(--navy);min-height:100vh;display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:100;}
    .sidebar-logo{padding:28px 24px 20px;border-bottom:1px solid rgba(255,255,255,0.08);}
    .logo-mark{display:flex;align-items:center;gap:10px;}
    .logo-icon{width:36px;height:36px;background:var(--accent);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;}
    .logo-text{font-family:'Space Mono',monospace;font-size:15px;font-weight:700;color:#fff;}
    .logo-sub{font-size:10px;color:rgba(255,255,255,0.4);font-family:'Space Mono',monospace;}
    .sidebar-section{padding:20px 16px 6px;}
    .sidebar-section-label{font-size:10px;font-weight:600;letter-spacing:1.2px;color:rgba(255,255,255,0.3);text-transform:uppercase;padding:0 8px;margin-bottom:6px;}
    .nav-item{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;cursor:pointer;color:rgba(255,255,255,0.55);font-size:14px;font-weight:500;transition:all 0.18s;margin-bottom:2px;text-decoration:none;}
    .nav-item:hover{background:rgba(255,255,255,0.08);color:#fff;}
    .nav-item.active{background:var(--accent);color:#fff;}
    .nav-icon{font-size:16px;width:20px;text-align:center;}
    .sidebar-footer{margin-top:auto;padding:16px;border-top:1px solid rgba(255,255,255,0.08);}
    .user-badge{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,0.06);border-radius:10px;}
    .user-avatar{width:34px;height:34px;border-radius:50%;background:var(--accent);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#fff;}
    .user-name{font-size:13px;font-weight:600;color:#fff;}
    .user-role{font-size:11px;color:rgba(255,255,255,0.4);}
    .main{margin-left:240px;flex:1;min-height:100vh;display:flex;flex-direction:column;}
    .topbar{background:var(--surface);border-bottom:1px solid var(--border);padding:16px 32px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
    .topbar-title h1{font-size:20px;font-weight:700;}
    .topbar-title p{font-size:13px;color:var(--text-muted);margin-top:1px;}
    .content{padding:28px 32px;flex:1;}
    .stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px;}
    .stat-card{background:var(--surface);border-radius:14px;padding:20px;border:1.5px solid var(--border);box-shadow:var(--shadow);display:flex;flex-direction:column;gap:12px;}
    .stat-header{display:flex;align-items:center;justify-content:space-between;}
    .stat-label{font-size:12px;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.6px;}
    .stat-icon{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:17px;}
    .stat-value{font-family:'Space Mono',monospace;font-size:28px;font-weight:700;}
    .stat-badge{display:inline-flex;align-items:center;gap:4px;font-size:11px;font-weight:600;padding:3px 8px;border-radius:20px;}
    .badge-green{background:var(--green-light);color:#16a34a;}
    .badge-amber{background:var(--amber-light);color:#b45309;}
    .badge-blue{background:var(--accent-light);color:var(--accent);}
    .section-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;}
    .card{background:var(--surface);border-radius:14px;border:1.5px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
    .card-header{padding:18px 20px 14px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
    .card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
    .card-title-icon{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:14px;background:var(--accent-light);}
    .card-body{padding:18px 20px;}
    .table-wrap{overflow-x:auto;}
    table{width:100%;border-collapse:collapse;font-size:13px;}
    thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.8px;border-bottom:1.5px solid var(--border);background:var(--bg);}
    tbody tr{border-bottom:1px solid var(--border);transition:background 0.12s;}
    tbody tr:hover{background:var(--bg);}
    td{padding:12px 14px;color:var(--text);vertical-align:middle;}
    .pill{display:inline-flex;align-items:center;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;}
    .pill-admin{background:var(--accent-light);color:var(--accent);}
    .pill-user{background:var(--green-light);color:#15803d;}
    .action-btn{padding:5px 12px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--text-muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
    .action-btn:hover{border-color:var(--red);color:var(--red);}
    .quick-links{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
    .quick-link{padding:16px;border-radius:10px;border:1.5px solid var(--border);background:var(--bg);text-decoration:none;color:var(--text);display:flex;align-items:center;gap:12px;transition:all 0.18s;font-size:13px;font-weight:600;}
    .quick-link:hover{border-color:var(--accent);color:var(--accent);}
    .quick-link-icon{width:36px;height:36px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:18px;background:var(--accent-light);}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="logo-mark">
      <div class="logo-icon">🅿️</div>
      <div><div class="logo-text">Park Smart</div>
    </div>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-section-label">Main</div>
    <a class="nav-item" href="home.jsp"><span class="nav-icon">⬛</span> Dashboard</a>
    <a class="nav-item" href="register"><span class="nav-icon">👤</span> User Registration</a>
    <a class="nav-item" href="slots"><span class="nav-icon">🅿️</span> Parking Slots</a>
    <a class="nav-item" href="reservations"><span class="nav-icon">📅</span> Reservations</a>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-section-label">System</div>
    <a class="nav-item" href="history"><span class="nav-icon">📋</span> Parking History</a>
    <a class="nav-item" href="billing.jsp"><span class="nav-icon">💳</span> Billing</a>
    <a class="nav-item" href="feedback.jsp"><span class="nav-icon">💬</span> Feedback</a>
    <a class="nav-item active" href="dashboard.jsp"><span class="nav-icon">⚙️</span> Admin Panel</a>
  </div>
  <div class="sidebar-footer">
    <div class="user-badge">
      <div class="user-avatar">A</div>
      <div><div class="user-name">Admin</div><div class="user-role">Administrator</div></div>
    </div>
  </div>
</aside>
<div class="main">
  <header class="topbar">
    <div class="topbar-title">
      <h1>Admin Panel</h1>
      <p>Manage users, slots and system overview</p>
    </div>
  </header>
  <div class="content">

    <!-- STATS -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-header"><span class="stat-label">Total Users</span><div class="stat-icon" style="background:#EEF1F8;">👥</div></div>
        <div class="stat-value">
          <%
            UserDAO adminUserDAO = new UserDAO();
            List<User> allAdminUsers = new ArrayList<>();
            try { allAdminUsers = adminUserDAO.getAllUsers(); } catch(Exception e) {}
            out.print(allAdminUsers.size());
          %>
        </div>
        <span class="stat-badge badge-green">Registered</span>
      </div>
      <div class="stat-card">
        <div class="stat-header"><span class="stat-label">Parking Slots</span><div class="stat-icon" style="background:#DCFCE7;">🅿️</div></div>
        <div class="stat-value">12</div>
        <span class="stat-badge badge-blue">Total slots</span>
      </div>
      <div class="stat-card">
        <div class="stat-header"><span class="stat-label">Active Sessions</span><div class="stat-icon" style="background:#FEE2E2;">🚗</div></div>
        <div class="stat-value">—</div>
        <span class="stat-badge badge-amber">Live</span>
      </div>
      <div class="stat-card">
        <div class="stat-header"><span class="stat-label">System Status</span><div class="stat-icon" style="background:#DCFCE7;">✅</div></div>
        <div class="stat-value" style="font-size:16px;margin-top:4px;">Online</div>
        <span class="stat-badge badge-green">All systems go</span>
      </div>
    </div>

    <div class="section-grid">

      <!-- USERS TABLE -->
      <div class="card" style="grid-column:1/-1;">
        <div class="card-header">
          <div class="card-title"><div class="card-title-icon">👥</div>All Registered Users</div>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>User ID</th><th>Name</th><th>Contact</th>
                <th>Username</th><th>Vehicle No</th><th>Vehicle Type</th><th>Role</th><th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% for (User u : allAdminUsers) { %>
              <tr>
                <td><code style="font-size:12px;color:var(--text-muted);">#<%= u.getUserId() %></code></td>
                <td><strong><%= u.getName() %></strong></td>
                <td><%= u.getContact() %></td>
                <td><%= u.getUsername() %></td>
                <td><span style="font-family:'Space Mono',monospace;font-size:12px;background:var(--navy);color:#fff;padding:3px 9px;border-radius:5px;"><%= u.getVehicleNo() != null ? u.getVehicleNo() : "—" %></span></td>
                <td><%= u.getVehicleType() != null ? u.getVehicleType() : "—" %></td>
                <td><span class="pill <%= "admin".equals(u.getRole()) ? "pill-admin" : "pill-user" %>"><%= u.getRole() %></span></td>
                <td>
                  <form action="deleteUser" method="post" style="display:inline;">
                    <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                    <button type="submit" class="action-btn" onclick="return confirm('Delete this user?')">Delete</button>
                  </form>
                </td>
              </tr>
              <% } %>
              <% if (allAdminUsers.isEmpty()) { %>
              <tr><td colspan="8" style="text-align:center;color:var(--text-muted);padding:24px;">No users registered yet.</td></tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <!-- QUICK LINKS -->
      <div class="card">
        <div class="card-header">
          <div class="card-title"><div class="card-title-icon">🔗</div>Quick Navigation</div>
        </div>
        <div class="card-body">
          <div class="quick-links">
            <a href="register" class="quick-link"><div class="quick-link-icon">👤</div>Register User</a>
            <a href="slots" class="quick-link"><div class="quick-link-icon">🅿️</div>View Slots</a>
            <a href="history" class="quick-link"><div class="quick-link-icon">📋</div>View History</a>
            <a href="feedback.jsp" class="quick-link"><div class="quick-link-icon">💬</div>View Feedback</a>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>
</body>
</html>
