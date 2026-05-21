<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; }
  String stName = (String) session.getAttribute("name");
  if (stName == null) stName = "Admin";
  List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
  if (staffList == null) staffList = new ArrayList<>();
  Staff editStaff = (Staff) request.getAttribute("editStaff");
  boolean isEditing = editStaff != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Staff Management</title>
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
.page-grid{display:grid;grid-template-columns:380px 1fr;gap:20px;align-items:start;}
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:20px;}
.form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:13px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input,.form-select{padding:10px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;outline:none;width:100%;}
.form-input:focus,.form-select:focus{border-color:var(--accent);background:#fff;}
.form-input::placeholder{color:#cbd5e1;}
.btn-add{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;}
.btn-save{background:linear-gradient(135deg,#F59E0B,#d97706);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;}
.btn-cancel{background:transparent;border:1.5px solid var(--border);color:var(--muted);padding:10px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;text-decoration:none;display:block;text-align:center;margin-bottom:8px;}
.edit-banner{background:#FEF3C7;border:1px solid #fcd34d;border-radius:9px;padding:11px 14px;font-size:13px;color:#92400e;font-weight:600;margin-bottom:14px;display:flex;align-items:center;gap:8px;}
.alert{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;}
.alert-s{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:11px 14px;vertical-align:middle;}
.del-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}
.edit-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;border:1.5px solid #fcd34d;background:#FEF3C7;color:#92400e;text-decoration:none;display:inline-flex;transition:all 0.15s;}
.edit-btn:hover{background:#F59E0B;color:#fff;border-color:#F59E0B;}
.badge{display:inline-flex;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px;}
.pos-sec{background:#DBEAFE;color:#1d4ed8;}
.pos-bil{background:var(--green-light);color:#15803d;}
.pos-att{background:var(--amber-light);color:#b45309;}
.pos-mgr{background:#F3E8FF;color:#7e22ce;}
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
    <a class="sb-item active" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= stName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= stName %></div><div class="sb-urole">Admin</div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Staff Management</h1><p>Add, edit and remove parking facility staff</p></div>
    <a href="logout" class="btn-logout">⏏ Logout</a>
  </header>
  <div class="content">
    <% if ("true".equals(request.getParameter("success"))) { %>
    <div class="alert alert-s">✅ Staff member added!</div>
    <% } else if ("updated".equals(request.getParameter("success"))) { %>
    <div class="alert alert-s">✅ Staff member updated!</div>
    <% } %>
    <div class="page-grid">

      <!-- ADD / EDIT FORM -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title">
            <div class="card-ico"><%= isEditing ? "✏️" : "👷" %></div>
            <%= isEditing ? "Edit Staff Member" : "Add Staff Member" %>
          </div>
        </div>
        <div class="card-body">
          <% if (isEditing) { %>
          <div class="edit-banner">✏️ Editing: <strong><%= editStaff.getName() %></strong></div>
          <form action="editStaff" method="post">
            <input type="hidden" name="staffId" value="<%= editStaff.getStaffId() %>"/>
            <div class="form-group"><label class="form-label">Full Name</label>
              <input class="form-input" type="text" name="name" value="<%= editStaff.getName() %>" required/></div>
            <div class="form-group"><label class="form-label">Email</label>
              <input class="form-input" type="email" name="email" value="<%= editStaff.getEmail() != null ? editStaff.getEmail() : "" %>"/></div>
            <div class="form-group"><label class="form-label">Phone</label>
              <input class="form-input" type="text" name="phone" value="<%= editStaff.getPhone() != null ? editStaff.getPhone() : "" %>"/></div>
            <div class="form-group"><label class="form-label">Position</label>
              <select class="form-select" name="position">
                <option value="Security Guard"    <%= "Security Guard".equals(editStaff.getPosition())    ? "selected" : "" %>>Security Guard</option>
                <option value="Billing Staff"     <%= "Billing Staff".equals(editStaff.getPosition())     ? "selected" : "" %>>Billing Staff</option>
                <option value="Parking Attendant" <%= "Parking Attendant".equals(editStaff.getPosition()) ? "selected" : "" %>>Parking Attendant</option>
                <option value="Manager"           <%= "Manager".equals(editStaff.getPosition())           ? "selected" : "" %>>Manager</option>
              </select></div>
            <div class="form-group"><label class="form-label">Permissions</label>
              <select class="form-select" name="permissions">
                <option value="entry_exit"         <%= "entry_exit".equals(editStaff.getPermissions())         ? "selected" : "" %>>Entry/Exit Only</option>
                <option value="billing"            <%= "billing".equals(editStaff.getPermissions())            ? "selected" : "" %>>Billing Only</option>
                <option value="entry_exit,billing" <%= "entry_exit,billing".equals(editStaff.getPermissions()) ? "selected" : "" %>>Entry/Exit + Billing</option>
                <option value="all"                <%= "all".equals(editStaff.getPermissions())                ? "selected" : "" %>>All Access</option>
              </select></div>
            <a href="staff" class="btn-cancel">Cancel</a>
            <button type="submit" class="btn-save">Save Changes →</button>
          </form>

          <% } else { %>
          <form action="staff" method="post">
            <input type="hidden" name="action" value="add"/>
            <div class="form-group"><label class="form-label">Full Name</label>
              <input class="form-input" type="text" name="name" placeholder="e.g. Kamal Perera" required/></div>
            <div class="form-group"><label class="form-label">Email</label>
              <input class="form-input" type="email" name="email" placeholder="kamal@parksmart.lk"/></div>
            <div class="form-group"><label class="form-label">Phone</label>
              <input class="form-input" type="text" name="phone" placeholder="07X XXX XXXX"/></div>
            <div class="form-group"><label class="form-label">Position</label>
              <select class="form-select" name="position">
                <option value="Security Guard">Security Guard</option>
                <option value="Billing Staff">Billing Staff</option>
                <option value="Parking Attendant">Parking Attendant</option>
                <option value="Manager">Manager</option>
              </select></div>
            <div class="form-group"><label class="form-label">Permissions</label>
              <select class="form-select" name="permissions">
                <option value="entry_exit">Entry/Exit Only</option>
                <option value="billing">Billing Only</option>
                <option value="entry_exit,billing">Entry/Exit + Billing</option>
                <option value="all">All Access</option>
              </select></div>
            <button type="submit" class="btn-add">Add Staff Member →</button>
          </form>
          <% } %>
        </div>
      </div>

      <!-- STAFF TABLE with Edit + Delete -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title"><div class="card-ico">📋</div>Current Staff</div>
          <span class="count-b"><%= staffList.size() %> members</span>
        </div>
        <% if (staffList.isEmpty()) { %>
        <div style="text-align:center;padding:32px;color:var(--muted);font-size:13px;">No staff added yet.</div>
        <% } else { %>
        <table>
          <thead><tr><th>ID</th><th>Name & Email</th><th>Phone</th><th>Position</th><th>Permissions</th><th>Actions</th></tr></thead>
          <tbody>
            <% for (Staff s : staffList) {
              String posCls = "pos-att";
              if ("Security Guard".equals(s.getPosition()))    posCls = "pos-sec";
              else if ("Billing Staff".equals(s.getPosition())) posCls = "pos-bil";
              else if ("Manager".equals(s.getPosition()))       posCls = "pos-mgr";
            %>
            <tr>
              <td style="color:var(--muted);font-size:12px;">#<%= String.format("%03d", s.getStaffId()) %></td>
              <td>
                <strong><%= s.getName() %></strong><br/>
                <span style="font-size:11px;color:var(--muted);"><%= s.getEmail() != null ? s.getEmail() : "" %></span>
              </td>
              <td style="font-size:12px;"><%= s.getPhone() != null ? s.getPhone() : "—" %></td>
              <td><span class="badge <%= posCls %>"><%= s.getPosition() %></span></td>
              <td style="font-size:11px;color:var(--muted);"><%= s.getPermissions() %></td>
              <td style="display:flex;gap:6px;">
                <a href="editStaff?staffId=<%= s.getStaffId() %>" class="edit-btn">Edit</a>
                <form action="staff" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="delete"/>
                  <input type="hidden" name="staffId" value="<%= s.getStaffId() %>"/>
                  <button type="submit" class="del-btn" onclick="return confirm('Remove staff?')">Remove</button>
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
