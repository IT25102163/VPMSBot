<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String regName = (String) session.getAttribute("name");
  String regRole = (String) session.getAttribute("role");
  if (regName == null) regName = "User";
  if (regRole == null) regRole = "user";
  boolean isAdmin = "admin".equals(regRole);

  UserDAO regDAO = new UserDAO();
  List<User> regUsers = new ArrayList<>();
  if (isAdmin) { try { regUsers = regDAO.getAllUsers(); } catch(Exception e) {} }

  User editUser = (User) request.getAttribute("editUser");
  boolean isEditing = editUser != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — User Registration</title>
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
.page-grid{display:grid;grid-template-columns:420px 1fr;gap:20px;align-items:start;}
.form-only{max-width:520px;}
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:22px;}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.form-group{display:flex;flex-direction:column;gap:5px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input,.form-select{padding:10px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;outline:none;width:100%;}
.form-input:focus,.form-select:focus{border-color:var(--accent);background:#fff;}
.form-input:disabled{background:#f1f5f9;color:var(--muted);cursor:not-allowed;}
.form-input::placeholder{color:#cbd5e1;}
.sec-div{font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;grid-column:1/-1;padding:8px 0 2px;border-top:1px solid var(--border);margin-top:4px;}
.edit-banner{background:#FEF3C7;border:1px solid #fcd34d;border-radius:9px;padding:11px 14px;font-size:13px;color:#92400e;font-weight:600;margin-bottom:14px;display:flex;align-items:center;gap:8px;}
.form-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:16px;}
.btn-cancel{background:transparent;border:1.5px solid var(--border);color:var(--muted);padding:10px 18px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;text-decoration:none;display:inline-flex;align-items:center;}
.btn-reg{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;padding:10px 24px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;}
.btn-save{background:linear-gradient(135deg,#F59E0B,#d97706);color:#fff;border:none;padding:10px 24px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;}
.alert{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;}
.alert-s{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
.alert-e{background:var(--red-light);color:#dc2626;border:1px solid #fca5a5;}
.alert-w{background:var(--amber-light);color:#b45309;border:1px solid #fcd34d;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:11px 14px;vertical-align:middle;}
.vtag{font-size:11px;font-weight:700;background:var(--navy);color:#fff;padding:3px 9px;border-radius:5px;}
.pill{display:inline-flex;padding:3px 8px;border-radius:20px;font-size:11px;font-weight:600;}
.pc{background:var(--accent-light);color:var(--accent);}
.pb{background:var(--amber-light);color:#92400e;}
.pv{background:var(--green-light);color:#15803d;}
.uid{font-size:12px;color:var(--muted);font-weight:600;}
.del-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}
.edit-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;border:1.5px solid #fcd34d;background:#FEF3C7;color:#92400e;text-decoration:none;display:inline-flex;transition:all 0.15s;}
.edit-btn:hover{background:#F59E0B;color:#fff;border-color:#F59E0B;}
.badge{display:inline-flex;font-size:11px;font-weight:600;padding:3px 9px;border-radius:20px;}
.bb{background:var(--accent-light);color:var(--accent);}
.bg-b{background:var(--green-light);color:#15803d;}
.count-b{background:var(--accent-light);color:var(--accent);font-size:12px;font-weight:700;padding:4px 10px;border-radius:20px;}
</style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-logo"><div class="sb-brand"><div class="sb-icon">P</div><div class="sb-name">ParkSmart</div></div></div>
  <div class="sb-sec">
    <div class="sb-lbl">Main</div>
    <a class="sb-item" href="home.jsp"><div class="sb-ico">⬛</div>Dashboard</a>
    <a class="sb-item active" href="register"><div class="sb-ico">👤</div>User Registration</a>
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
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= regName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= regName %></div><div class="sb-urole"><%= regRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left">
      <h1><%= isEditing ? "Edit User" : "User Registration" %></h1>
      <p><%= isEditing ? "Update user profile and vehicle details" : "Register new users and vehicles" %></p>
    </div>
    <a href="#" onclick="if(confirm('Are you sure you want to logout?'))window.location.href='logout'" class="btn-logout">⏏ Logout</a>
  </header>
  <div class="content">
    <% String err = request.getParameter("error"); String suc = request.getParameter("success"); %>
    <% if ("true".equals(suc))    { %><div class="alert alert-s">✅ User registered successfully!</div><% } %>
    <% if ("updated".equals(suc)) { %><div class="alert alert-s">✅ User updated successfully!</div><% } %>
    <% if ("username".equals(err)){ %><div class="alert alert-w">⚠️ Username already exists.</div><% } %>
    <% if ("vehicle".equals(err)) { %><div class="alert alert-w">⚠️ Vehicle number already registered.</div><% } %>
    <% if ("true".equals(err))    { %><div class="alert alert-e">❌ Operation failed. Please try again.</div><% } %>

    <div class="<%= isAdmin ? "page-grid" : "form-only" %>">
      <!-- FORM -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title">
            <div class="card-ico"><%= isEditing ? "✏️" : "👤" %></div>
            <%= isEditing ? "Edit User #" + editUser.getUserId() : "New User & Vehicle" %>
          </div>
          <% if (isEditing) { %><a href="register" class="btn-cancel" style="font-size:12px;padding:6px 12px;">← Back</a><% } %>
        </div>
        <div class="card-body">
          <% if (isEditing) { %>
          <div class="edit-banner">✏️ Editing: <strong><%= editUser.getName() %></strong> (@<%= editUser.getUsername() %>)</div>
          <form action="editUser" method="post">
            <input type="hidden" name="userId" value="<%= editUser.getUserId() %>"/>
            <div class="form-grid">
              <div class="sec-div">👤 User Information</div>
              <div class="form-group">
                <label class="form-label">Full Name</label>
                <input class="form-input" type="text" name="name" value="<%= editUser.getName() %>" required/>
              </div>
              <div class="form-group">
                <label class="form-label">Contact No.</label>
                <input class="form-input" type="text" name="contact" value="<%= editUser.getContact() != null ? editUser.getContact() : "" %>" required/>
              </div>
              <div class="form-group" style="grid-column:1/-1;">
                <label class="form-label">Username (cannot change)</label>
                <input class="form-input" type="text" value="<%= editUser.getUsername() %>" disabled/>
              </div>
              <div class="sec-div">🚗 Vehicle Information</div>
              <div class="form-group">
                <label class="form-label">Vehicle Number</label>
                <input class="form-input" type="text" name="vehicleNo"
                       value="<%= editUser.getVehicleNo() != null ? editUser.getVehicleNo() : "" %>"
                       oninput="this.value=this.value.toUpperCase()"/>
              </div>
              <div class="form-group">
                <label class="form-label">Vehicle Type</label>
                <select class="form-select" name="vehicleType">
                  <option value="Car"          <%= "Car".equals(editUser.getVehicleType())          ? "selected" : "" %>>Car</option>
                  <option value="Motorbike"     <%= "Motorbike".equals(editUser.getVehicleType())     ? "selected" : "" %>>Motorbike</option>
                  <option value="Van"           <%= "Van".equals(editUser.getVehicleType())           ? "selected" : "" %>>Van</option>
                  <option value="Three-Wheeler" <%= "Three-Wheeler".equals(editUser.getVehicleType()) ? "selected" : "" %>>Three-Wheeler</option>
                </select>
              </div>
            </div>
            <div class="form-actions">
              <a href="register" class="btn-cancel">Cancel</a>
              <button type="submit" class="btn-save">Save Changes →</button>
            </div>
          </form>
          <% } else { %>
          <form action="register" method="post">
            <input type="hidden" name="from" value="dashboard"/>
            <div class="form-grid">
              <div class="sec-div">👤 User Information</div>
              <div class="form-group">
                <label class="form-label">Full Name</label>
                <input class="form-input" type="text" name="name" placeholder="Kasuni Perera" required/>
              </div>
              <div class="form-group">
                <label class="form-label">Contact No.</label>
                <input class="form-input" type="text" name="contact" placeholder="07X XXX XXXX" required/>
              </div>
              <div class="form-group">
                <label class="form-label">Username</label>
                <input class="form-input" type="text" name="username" placeholder="kasuni2024" required/>
              </div>
              <div class="form-group">
                <label class="form-label">Password</label>
                <input class="form-input" type="password" name="password" placeholder="••••••••" required/>
              </div>
              <div class="sec-div">🚗 Vehicle Information</div>
              <div class="form-group">
                <label class="form-label">Vehicle Number</label>
                <input class="form-input" type="text" name="vehicleNo" placeholder="CAR-1234"
                       oninput="this.value=this.value.toUpperCase()"/>
              </div>
              <div class="form-group">
                <label class="form-label">Vehicle Type</label>
                <select class="form-select" name="vehicleType">
                  <option value="Car">Car</option>
                  <option value="Motorbike">Motorbike</option>
                  <option value="Van">Van</option>
                  <option value="Three-Wheeler">Three-Wheeler</option>
                </select>
              </div>
            </div>
            <div class="form-actions">
              <button type="reset" class="btn-cancel">Clear</button>
              <button type="submit" class="btn-reg">Register →</button>
            </div>
          </form>
          <% } %>
        </div>
      </div>

      <!-- ADMIN TABLE -->
      <% if (isAdmin) { %>
      <div class="card">
        <div class="card-hdr">
          <div class="card-title"><div class="card-ico">📋</div>All Registered Users</div>
          <span class="count-b"><%= regUsers.size() %> total</span>
        </div>
        <table>
          <thead><tr><th>ID</th><th>Name</th><th>Username</th><th>Vehicle</th><th>Type</th><th>Role</th><th>Actions</th></tr></thead>
          <tbody>
            <% for (User u : regUsers) {
               String vType = u.getVehicleType() != null ? u.getVehicleType() : "—";
               String pCls = "pc";
               if ("Motorbike".equals(vType)) pCls = "pb";
               else if ("Van".equals(vType)) pCls = "pv";
            %>
            <tr>
              <td><span class="uid">#<%= String.format("%03d", u.getUserId()) %></span></td>
              <td><strong><%= u.getName() %></strong></td>
              <td style="font-size:12px;color:var(--muted);"><%= u.getUsername() %></td>
              <td><span class="vtag"><%= u.getVehicleNo() != null && !u.getVehicleNo().isEmpty() ? u.getVehicleNo() : "—" %></span></td>
              <td><span class="pill <%= pCls %>"><%= vType %></span></td>
              <td><span class="badge <%= "admin".equals(u.getRole()) ? "bb" : "bg-b" %>"><%= u.getRole() %></span></td>
              <td style="display:flex;gap:6px;">
                <a href="editUser?userId=<%= u.getUserId() %>" class="edit-btn">Edit</a>
                <form action="deleteUser" method="post" style="display:inline;">
                  <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                  <button type="submit" class="del-btn" onclick="return confirm('Delete this user?')">Delete</button>
                </form>
              </td>
            </tr>
            <% } %>
            <% if (regUsers.isEmpty()) { %>
            <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:24px;">No users yet.</td></tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <% } %>
    </div>
  </div>
</div>
</body>
</html>
