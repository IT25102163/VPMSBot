<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Park Smart — Vehicle Exit</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet"/>
  <style>
    :root{--bg:#F4F6FB;--surface:#FFFFFF;--navy:#1A2340;--accent:#4F6EF7;--accent-light:#E8ECFF;--green:#22C55E;--green-light:#DCFCE7;--red:#EF4444;--red-light:#FEE2E2;--amber:#F59E0B;--amber-light:#FEF3C7;--text:#1A2340;--text-muted:#6B7A99;--border:#DDE3F0;--shadow:0 2px 16px rgba(26,35,64,0.07);}
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
    .section-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;}
    .card{background:var(--surface);border-radius:14px;border:1.5px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
    .card-header{padding:18px 20px 14px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;gap:10px;}
    .card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
    .card-title-icon{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:14px;background:var(--red-light);}
    .card-body{padding:18px 20px;}
    .form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:14px;}
    .form-label{font-size:12px;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.5px;}
    .form-input{padding:11px 14px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:var(--bg);transition:border-color 0.18s;outline:none;}
    .form-input:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(79,110,247,0.1);}
    .btn{display:inline-flex;align-items:center;gap:7px;padding:10px 20px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;border:none;transition:all 0.18s;font-family:'DM Sans',sans-serif;}
    .btn-danger{background:var(--red);color:#fff;width:100%;justify-content:center;}
    .btn-danger:hover{background:#dc2626;}
    .alert{padding:14px 18px;border-radius:10px;font-size:13px;margin-bottom:20px;font-weight:500;}
    .alert-success{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
    .alert-error{background:var(--red-light);color:#dc2626;border:1px solid #fca5a5;}
    .receipt-box{background:var(--bg);border-radius:10px;border:1.5px solid var(--border);padding:20px;}
    .receipt-title{font-family:'Space Mono',monospace;font-size:13px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:1px;margin-bottom:14px;text-align:center;}
    .receipt-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px;}
    .receipt-row:last-child{border-bottom:none;font-weight:700;font-size:15px;}
    .receipt-label{color:var(--text-muted);}
    .receipt-value{font-family:'Space Mono',monospace;}
    .receipt-total{color:var(--accent);font-size:20px;}
    .info-box{background:var(--amber-light);border:1.5px solid #fcd34d;border-radius:10px;padding:14px;font-size:13px;color:#92400e;margin-bottom:16px;}
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
    <a class="nav-item active" href="exit.jsp"><span class="nav-icon">🚪</span> Vehicle Exit</a>
    <a class="nav-item" href="billing.jsp"><span class="nav-icon">💳</span> Billing</a>
    <a class="nav-item" href="feedback.jsp"><span class="nav-icon">💬</span> Feedback</a>
    <a class="nav-item" href="dashboard.jsp"><span class="nav-icon">⚙️</span> Admin Panel</a>
  </div>
  <div class="sidebar-footer">
    <div class="user-badge">
      <div class="user-avatar">U</div>
      <div><div class="user-name">Security</div><div class="user-role">Guard</div></div>
    </div>
  </div>
</aside>
<div class="main">
  <header class="topbar">
    <div class="topbar-title">
      <h1>Vehicle Exit</h1>
      <p>Process vehicle exit and release parking slot</p>
    </div>
  </header>
  <div class="content">

    <% if ("true".equals(request.getParameter("success"))) { %>
      <div class="alert alert-success">✅ Vehicle exit processed. Slot released successfully!</div>
    <% } %>
    <% if ("true".equals(request.getParameter("error"))) { %>
      <div class="alert alert-error">❌ Vehicle not found or already exited.</div>
    <% } %>

    <div class="section-grid">

      <!-- EXIT FORM -->
      <div class="card">
        <div class="card-header">
          <div class="card-title"><div class="card-title-icon">🚪</div>Process Exit</div>
        </div>
        <div class="card-body">
          <div class="info-box">
            ⚠️ Enter the vehicle plate number to record exit time and release the parking slot.
          </div>
          <form action="security/exit" method="post">
            <div class="form-group">
              <label class="form-label">Vehicle Plate Number</label>
              <input class="form-input" type="text" name="vehicleNumber" placeholder="e.g. CAR-1234" required
                style="text-transform:uppercase;" oninput="this.value=this.value.toUpperCase()"/>
            </div>
            <button type="submit" class="btn btn-danger">🚪 Process Exit</button>
          </form>
        </div>
      </div>

      <!-- EXIT RECEIPT (shown after processing) -->
      <% if (request.getAttribute("exitSummary") != null) { %>
      <div class="card">
        <div class="card-header">
          <div class="card-title"><div class="card-title-icon">🧾</div>Exit Receipt</div>
        </div>
        <div class="card-body">
          <div class="receipt-box">
            <div class="receipt-title">🅿️ Park Smart Exit Receipt</div>
            <div class="receipt-row"><span class="receipt-label">Vehicle</span><span class="receipt-value"><%= request.getAttribute("vehicleNo") %></span></div>
            <div class="receipt-row"><span class="receipt-label">Slot Released</span><span class="receipt-value"><%= request.getAttribute("slotId") %></span></div>
            <div class="receipt-row"><span class="receipt-label">Entry Time</span><span class="receipt-value"><%= request.getAttribute("entryTime") %></span></div>
            <div class="receipt-row"><span class="receipt-label">Exit Time</span><span class="receipt-value"><%= request.getAttribute("exitTime") %></span></div>
            <div class="receipt-row"><span class="receipt-label">Duration</span><span class="receipt-value"><%= request.getAttribute("duration") %></span></div>
            <div class="receipt-row"><span class="receipt-label">Total Due</span><span class="receipt-value receipt-total"><%= request.getAttribute("totalFee") %></span></div>
          </div>
          <div style="margin-top:14px;text-align:center;">
            <a href="billing.jsp" class="btn" style="background:var(--accent);color:#fff;justify-content:center;text-decoration:none;">💳 Process Payment →</a>
          </div>
        </div>
      </div>
      <% } else { %>
      <div class="card">
        <div class="card-header">
          <div class="card-title"><div class="card-title-icon">ℹ️</div>How It Works</div>
        </div>
        <div class="card-body">
          <div style="display:flex;flex-direction:column;gap:14px;">
            <div style="display:flex;gap:12px;align-items:flex-start;">
              <div style="width:28px;height:28px;border-radius:50%;background:var(--accent-light);color:var(--accent);display:flex;align-items:center;justify-content:center;font-weight:700;flex-shrink:0;">1</div>
              <div><strong style="font-size:13px;">Enter vehicle plate</strong><div style="font-size:12px;color:var(--text-muted);margin-top:2px;">Type the vehicle's plate number in the form</div></div>
            </div>
            <div style="display:flex;gap:12px;align-items:flex-start;">
              <div style="width:28px;height:28px;border-radius:50%;background:var(--accent-light);color:var(--accent);display:flex;align-items:center;justify-content:center;font-weight:700;flex-shrink:0;">2</div>
              <div><strong style="font-size:13px;">Exit is recorded</strong><div style="font-size:12px;color:var(--text-muted);margin-top:2px;">System records exit time and calculates duration</div></div>
            </div>
            <div style="display:flex;gap:12px;align-items:flex-start;">
              <div style="width:28px;height:28px;border-radius:50%;background:var(--accent-light);color:var(--accent);display:flex;align-items:center;justify-content:center;font-weight:700;flex-shrink:0;">3</div>
              <div><strong style="font-size:13px;">Slot released</strong><div style="font-size:12px;color:var(--text-muted);margin-top:2px;">Parking slot becomes available for next vehicle</div></div>
            </div>
            <div style="display:flex;gap:12px;align-items:flex-start;">
              <div style="width:28px;height:28px;border-radius:50%;background:var(--accent-light);color:var(--accent);display:flex;align-items:center;justify-content:center;font-weight:700;flex-shrink:0;">4</div>
              <div><strong style="font-size:13px;">Process payment</strong><div style="font-size:12px;color:var(--text-muted);margin-top:2px;">Go to Billing to collect the parking fee</div></div>
            </div>
          </div>
        </div>
      </div>
      <% } %>

    </div>
  </div>
</div>
</body>
</html>
