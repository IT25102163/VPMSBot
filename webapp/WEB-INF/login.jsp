<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("userId") != null) {
      response.sendRedirect("home.jsp");
      return;
  }
  String mode = request.getParameter("mode");
  if (mode == null) mode = "login";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>ParkSmart — Login</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<style>
:root{--bg:#F0F4FF;--surface:#FFFFFF;--navy:#0f172a;--navy2:#1e293b;--accent:#6366f1;--accent2:#8b5cf6;--green:#22C55E;--green-light:#DCFCE7;--red:#EF4444;--red-light:#FEE2E2;--text:#0f172a;--muted:#64748b;--border:#e2e8f0;}
*{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'Inter',sans-serif;letter-spacing:0.2px;background:var(--bg);min-height:100vh;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;}
/* Background */
.bg-blob{position:fixed;border-radius:50%;pointer-events:none;filter:blur(60px);opacity:0.5;}
.b1{width:500px;height:500px;background:rgba(99,102,241,0.15);top:-150px;left:-150px;}
.b2{width:400px;height:400px;background:rgba(139,92,246,0.12);bottom:-100px;right:-100px;}
.b3{width:300px;height:300px;background:rgba(99,102,241,0.08);top:40%;left:40%;}
/* Card */
.card{position:relative;z-index:1;display:flex;width:100%;max-width:960px;min-height:580px;border-radius:28px;overflow:hidden;box-shadow:0 25px 60px rgba(15,23,42,0.15),0 0 0 1px rgba(255,255,255,0.5);}
/* Left */
.left{background:linear-gradient(150deg,#0f172a 0%,#1e293b 40%,#312e81 100%);flex:1.1;padding:56px 52px;display:flex;flex-direction:column;justify-content:space-between;position:relative;overflow:hidden;}
.left-glow{position:absolute;border-radius:50%;pointer-events:none;}
.g1{width:280px;height:280px;background:rgba(99,102,241,0.2);top:-80px;right:-80px;}
.g2{width:200px;height:200px;background:rgba(139,92,246,0.15);bottom:-60px;left:-60px;}
.left-top{position:relative;z-index:1;}
/* Brand */
.brand{display:flex;align-items:center;gap:14px;margin-bottom:52px;}
.brand-icon{width:48px;height:48px;background:linear-gradient(135deg,#6366f1,#8b5cf6);border-radius:14px;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 24px rgba(99,102,241,0.5);flex-shrink:0;}
.brand-p{font-family:'Poppins',sans-serif;font-size:22px;font-weight:800;color:#fff;}
.brand-name{
  font-size:24px;
  letter-spacing:-0.5px;font-weight:800;color:#fff;letter-spacing:-0.5px;}
/* Heading */
.left-heading{
  font-family:'Poppins',sans-serif;
  font-size:40px;
  letter-spacing:-0.5px;font-weight:800;color:#fff;line-height:1.2;margin-bottom:16px;}
.left-heading span{background:linear-gradient(90deg,#a5b4fc,#c084fc);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
.left-desc{font-size:14px;color:rgba(255,255,255,0.5);line-height:1.8;margin-bottom:36px;}
/* Features */
.features{display:flex;flex-direction:column;gap:14px;}
.feat{display:flex;align-items:center;gap:12px;}
.feat-dot{width:8px;height:8px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);flex-shrink:0;}
.feat-text{font-size:13px;color:rgba(255,255,255,0.65);font-weight:500;}
/* Bottom */
.left-bottom{position:relative;z-index:1;display:flex;align-items:center;gap:8px;font-size:12px;color:rgba(255,255,255,0.3);}
.live-dot{width:6px;height:6px;border-radius:50%;background:#22C55E;animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{box-shadow:0 0 0 0 rgba(34,197,94,0.4);}50%{box-shadow:0 0 0 6px rgba(34,197,94,0);}}
/* Right */
.right{background:#fff;flex:1;padding:52px 48px;display:flex;flex-direction:column;justify-content:center;}
/* Mode toggle */
.mode-toggle{display:flex;background:#f1f5f9;border-radius:12px;padding:4px;margin-bottom:32px;}
.mode-btn{flex:1;padding:10px;border:none;border-radius:9px;font-size:14px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s;color:#64748b;background:transparent;}
.mode-btn.active{background:#fff;color:#0f172a;box-shadow:0 2px 8px rgba(15,23,42,0.1);}
/* Form panels */
.panel{display:none;}
.panel.active{display:block;}
.panel-title{
  font-family:'Poppins',sans-serif;
  font-size:24px;
  letter-spacing:-0.3px;font-weight:800;color:var(--text);margin-bottom:6px;}
.panel-sub{font-size:13px;color:var(--muted);margin-bottom:24px;line-height:1.6;}
/* Alert */
.alert{padding:11px 14px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;display:none;align-items:center;gap:8px;}
.alert.show{display:flex;}
.alert-error{background:#FEE2E2;color:#dc2626;border:1px solid #fca5a5;}
.alert-success{background:#DCFCE7;color:#15803d;border:1px solid #86efac;}
.alert-warning{background:#FEF3C7;color:#b45309;border:1px solid #fcd34d;}
/* Form */
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:14px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input{padding:12px 14px;border:1.5px solid var(--border);border-radius:9px;font-size:13px;font-family:'Inter',sans-serif;color:var(--text);background:#f8fafc;outline:none;transition:all 0.2s;}
.form-input:focus{border-color:#6366f1;background:#fff;box-shadow:0 0 0 4px rgba(99,102,241,0.08);}
.form-select{padding:12px 14px;border:1.5px solid var(--border);border-radius:9px;font-size:13px;font-family:'Inter',sans-serif;color:var(--text);background:#f8fafc;outline:none;}
.form-input::placeholder{color:#cbd5e1;}
/* Button */
.btn-submit{width:100%;padding:13px;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;border-radius:10px;font-size:14px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;box-shadow:0 4px 16px rgba(99,102,241,0.35);transition:all 0.2s;margin-top:4px;}
.btn-submit:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(99,102,241,0.45);}
/* Status */
.status-bar{margin-top:20px;display:flex;align-items:center;justify-content:center;gap:7px;font-size:12px;color:#cbd5e1;}
.status-dot2{width:6px;height:6px;border-radius:50%;background:#22C55E;animation:pulse 2s infinite;}
</style>
</head>
<body>
<div class="bg-blob b1"></div>
<div class="bg-blob b2"></div>
<div class="bg-blob b3"></div>

<div class="card">
  <!-- LEFT -->
  <div class="left">
    <div class="left-top">
      <div class="brand">
        <div class="brand-icon"><div class="brand-p">P</div></div>
        <div class="brand-name">ParkSmart</div>
      </div>
      <div class="left-heading">Smart Parking<br/><span>Made Simple</span></div>
      <div class="left-desc">Manage vehicles, monitor slots and process payments all in one place.</div>
      <div class="features">
        <div class="feat"><div class="feat-dot"></div><div class="feat-text">Real-time slot monitoring</div></div>
        <div class="feat"><div class="feat-dot"></div><div class="feat-text">Automated billing system</div></div>
        <div class="feat"><div class="feat-dot"></div><div class="feat-text">Complete parking history</div></div>
        <div class="feat"><div class="feat-dot"></div><div class="feat-text">Admin control panel</div></div>
      </div>
    </div>
    <div class="left-glow g1"></div>
    <div class="left-glow g2"></div>
    <div class="left-bottom">
      <div class="live-dot"></div>
      System Online · All services running
    </div>
  </div>

  <!-- RIGHT -->
  <div class="right">
    <!-- Mode Toggle -->
    <div class="mode-toggle">
      <button class="mode-btn <%= "login".equals(mode) ? "active" : "" %>" onclick="switchMode('login')" id="btn-login">Sign In</button>
      <button class="mode-btn <%= "register".equals(mode) ? "active" : "" %>" onclick="switchMode('register')" id="btn-register">Register</button>
    </div>

    <!-- LOGIN PANEL -->
    <div class="panel <%= "login".equals(mode) ? "active" : "" %>" id="panel-login">
      <div class="panel-title">Welcome Back</div>
      <div class="panel-sub">Sign in to access the parking system</div>

      <div class="alert alert-error" id="loginError">❌ Invalid username or password.</div>
      <div class="alert alert-success" id="logoutMsg">✅ Logged out successfully.</div>

      <form action="login" method="post">
        <div class="form-group">
          <label class="form-label">Username</label>
          <input class="form-input" type="text" name="username" placeholder="Enter your username" required/>
        </div>
        <div class="form-group">
          <label class="form-label">Password</label>
          <input class="form-input" type="password" name="password" placeholder="Enter your password" required/>
        </div>
        <button class="btn-submit" type="submit">Sign In →</button>
      </form>
    </div>

    <!-- REGISTER PANEL -->
    <div class="panel <%= "register".equals(mode) ? "active" : "" %>" id="panel-register">
      <div class="panel-title">Create Account</div>
      <div class="panel-sub">Register to use the parking system</div>

      <div class="alert alert-error" id="regError">❌ Registration failed.</div>
      <div class="alert alert-warning" id="regUsername">⚠️ Username already exists. Try another.</div>
      <div class="alert alert-warning" id="regVehicle">⚠️ Vehicle number already registered.</div>
      <div class="alert alert-success" id="regSuccess">✅ Registered successfully! Please sign in.</div>

      <form action="register" method="post">
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Full Name</label>
            <input class="form-input" type="text" name="name" placeholder="Kasuni Perera" required/>
          </div>
          <div class="form-group">
            <label class="form-label">Contact No.</label>
            <input class="form-input" type="text" name="contact" placeholder="07X XXX XXXX" required/>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Username</label>
            <input class="form-input" type="text" name="username" placeholder="kasuni2024" required/>
          </div>
          <div class="form-group">
            <label class="form-label">Password</label>
            <input class="form-input" type="password" name="password" placeholder="••••••••" required/>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Vehicle Number</label>
            <input class="form-input" type="text" name="vehicleNo" placeholder="CAR-1234" style="text-transform:uppercase;" oninput="this.value=this.value.toUpperCase()"/>
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
        <button class="btn-submit" type="submit">Create Account →</button>
      </form>
    </div>

    <div class="status-bar">
      <div class="status-dot2"></div>
      ParkSmart Vehicle Parking Management System
    </div>
  </div>
</div>

<script>
function switchMode(mode) {
  document.getElementById('panel-login').classList.toggle('active', mode==='login');
  document.getElementById('panel-register').classList.toggle('active', mode==='register');
  document.getElementById('btn-login').classList.toggle('active', mode==='login');
  document.getElementById('btn-register').classList.toggle('active', mode==='register');
}

// Show alerts based on URL params
const p = new URLSearchParams(window.location.search);
if (p.get('error') === 'true') document.getElementById('loginError').classList.add('show');
if (p.get('logout') === 'true') document.getElementById('logoutMsg').classList.add('show');

// Register alerts — also switch to register tab
if (p.get('error') === 'username') {
  switchMode('register');
  document.getElementById('regUsername').classList.add('show');
}
if (p.get('error') === 'vehicle') {
  switchMode('register');
  document.getElementById('regVehicle').classList.add('show');
}
if (p.get('success') === 'true' && p.get('from') === 'register') {
  document.getElementById('regSuccess').classList.add('show');
}
</script>
</body>
</html>
