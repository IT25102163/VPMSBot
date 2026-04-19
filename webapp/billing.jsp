<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String bName = (String) session.getAttribute("name");
  String bRole = (String) session.getAttribute("role");
  int bUserId  = 0;
  try { bUserId = (int) session.getAttribute("userId"); } catch(Exception e) {}
  if (bName == null) bName = "User";
  if (bRole == null) bRole = "user";
  boolean isAdmin = "admin".equals(bRole);
  String userVehicleNo = "";
  try {
    User cu = new UserDAO().getUserById(bUserId);
    if (cu != null && cu.getVehicleNo() != null && !cu.getVehicleNo().isEmpty())
      userVehicleNo = cu.getVehicleNo();
  } catch(Exception e) {}
  boolean hasVehicle = !userVehicleNo.isEmpty();
  ParkingLotDAO billingDAO = new ParkingLotDAO();
  List<Billing> billings = new ArrayList<>();
  try { billings = billingDAO.getBillings(); } catch(Exception e) {}
  String billDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
  String billTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("hh:mm a"));
  int receiptNo   = billings.size() + 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Billing</title>
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
.layout{display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.card{background:var(--surface);border-radius:14px;border:1px solid var(--border);box-shadow:var(--shadow);overflow:hidden;}
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:8px;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:20px;}
.form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:13px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input,.form-select{padding:10px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;outline:none;width:100%;}
.form-input:focus,.form-select:focus{border-color:var(--accent);background:#fff;}
.form-input.locked{background:#f1f5f9;color:var(--text);font-weight:600;cursor:not-allowed;}
.form-input::placeholder{color:#cbd5e1;}
.summary-box{background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(139,92,246,0.04));border:1.5px solid rgba(99,102,241,0.2);border-radius:12px;padding:16px;margin-bottom:16px;}
.sum-row{display:flex;justify-content:space-between;padding:7px 0;border-bottom:1px solid rgba(99,102,241,0.1);font-size:13px;}
.sum-row:last-child{border-bottom:none;padding-top:12px;}
.sum-lbl{color:var(--muted);}
.sum-val{font-weight:600;}
.sum-total{color:var(--accent);font-size:22px;font-weight:700;}
.btn-print-save{width:100%;padding:14px;background:linear-gradient(135deg,#22C55E,#16a34a);color:#fff;border:none;border-radius:10px;font-size:15px;font-weight:700;cursor:pointer;font-family:'DM Sans',sans-serif;box-shadow:0 4px 14px rgba(34,197,94,0.3);transition:all 0.2s;display:flex;align-items:center;justify-content:center;gap:8px;}
.btn-print-save:hover{transform:translateY(-2px);}
.no-vehicle{background:#FEF3C7;border:1px solid #fcd34d;border-radius:8px;padding:10px 13px;font-size:12px;color:#92400e;margin-bottom:12px;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{text-align:left;padding:10px 14px;font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.7px;border-bottom:1.5px solid var(--border);background:#fafbff;}
tbody tr{border-bottom:1px solid var(--border);}
tbody tr:hover{background:#fafbff;}
td{padding:11px 14px;vertical-align:middle;}
.vtag{font-size:11px;font-weight:700;background:var(--navy);color:#fff;padding:3px 9px;border-radius:5px;}
.s-paid{background:var(--green-light);color:#15803d;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700;}
.s-pend{background:var(--amber-light);color:#b45309;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700;}
.del-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}

/* PRINT — hide everything, show only receipt */
#receiptArea{display:none;}
@media print{
  html,body{visibility:hidden;}
  #receiptArea{display:block!important;visibility:visible!important;position:fixed;top:0;left:0;width:100%;padding:48px;background:#fff;}
  #receiptArea *{visibility:visible!important;}
}
.receipt{max-width:420px;margin:0 auto;font-family:'DM Sans',sans-serif;}
.r-hdr{text-align:center;padding-bottom:20px;border-bottom:2px dashed #ccc;margin-bottom:20px;}
.r-logo{font-size:28px;font-weight:800;color:#0f172a;}
.r-sub{font-size:13px;color:#64748b;margin-top:4px;}
.r-tag{font-size:11px;color:#94a3b8;margin-top:3px;}
.r-row{display:flex;justify-content:space-between;padding:9px 0;border-bottom:1px solid #f1f5f9;font-size:14px;}
.r-key{color:#64748b;}
.r-val{font-weight:600;color:#0f172a;}
.r-total{display:flex;justify-content:space-between;padding:16px 0 8px;border-top:2px solid #0f172a;margin-top:10px;font-size:20px;font-weight:700;}
.r-foot{text-align:center;margin-top:24px;padding-top:16px;border-top:2px dashed #ccc;font-size:12px;color:#64748b;line-height:1.9;}
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
    <a class="sb-item active" href="billing"><div class="sb-ico">💳</div>Billing</a>
    <a class="sb-item" href="feedback.jsp"><div class="sb-ico">💬</div>Feedback</a>
    <a class="sb-item" href="reports.jsp"><div class="sb-ico">📊</div>Reports</a>
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= bName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= bName %></div><div class="sb-urole"><%= bRole %></div></div>
    </div>
  </div>
</aside>
<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Billing</h1><p>Generate parking receipts</p></div>
    <a href="logout" class="btn-logout">⏏ Logout</a>
  </header>
  <div class="content">
    <div class="layout">
      <div class="card">
        <div class="card-hdr"><div class="card-title"><div class="card-ico">💳</div>Generate Bill</div></div>
        <div class="card-body">
          <% if (!hasVehicle) { %><div class="no-vehicle">⚠️ No vehicle on your account. Enter below.</div><% } %>
          <div class="form-group">
            <label class="form-label">Vehicle Number</label>
            <% if (hasVehicle) { %>
            <input class="form-input locked" type="text" value="<%= userVehicleNo %>" readonly/>
            <% } else { %>
            <input class="form-input" type="text" id="f_vehicle" placeholder="e.g. CAR-1234" oninput="this.value=this.value.toUpperCase();update()"/>
            <% } %>
          </div>
          <div class="form-group">
            <label class="form-label">Customer Name</label>
            <input class="form-input locked" type="text" value="<%= bName %>" readonly/>
          </div>
          <div class="form-group">
            <label class="form-label">Hours Parked</label>
            <input class="form-input" type="number" id="f_hours" placeholder="e.g. 3" min="1" oninput="update()"/>
          </div>
          <div class="form-group">
            <label class="form-label">Payment Method</label>
            <select class="form-select" id="f_method" onchange="update()">
              <option value="Cash">Cash</option>
              <option value="Card">Card</option>
              <option value="Online Transfer">Online Transfer</option>
            </select>
          </div>
          <div class="summary-box">
            <div class="sum-row"><span class="sum-lbl">Vehicle</span><span class="sum-val" id="p_vehicle"><%= hasVehicle ? userVehicleNo : "—" %></span></div>
            <div class="sum-row"><span class="sum-lbl">Hours</span><span class="sum-val" id="p_hours">0 hour(s)</span></div>
            <div class="sum-row"><span class="sum-lbl">Rate/Hour</span><span class="sum-val">Rs. 100.00</span></div>
            <div class="sum-row"><span class="sum-lbl">Method</span><span class="sum-val" id="p_method">Cash</span></div>
            <div class="sum-row"><span class="sum-lbl">Total</span><span class="sum-total" id="p_total">Rs. 0.00</span></div>
          </div>
          <button class="btn-print-save" onclick="saveAndPrint()">🖨 Save &amp; Print Receipt</button>
        </div>
      </div>

      <% if (isAdmin) { %>
      <div class="card">
        <div class="card-hdr"><div class="card-title"><div class="card-ico">📋</div>All Payments</div></div>
        <table>
          <thead><tr><th>#</th><th>Vehicle</th><th>Amount</th><th>Method</th><th>Status</th><th>Action</th></tr></thead>
          <tbody>
            <% for (Billing b : billings) { %>
            <tr>
              <td style="color:var(--muted);font-size:12px;"><%= b.getId() %></td>
              <td><span class="vtag"><%= b.getVehicleNo() != null ? b.getVehicleNo() : "—" %></span></td>
              <td><strong>Rs. <%= String.format("%.2f", b.getAmount()) %></strong></td>
              <td style="font-size:12px;"><%= b.getPaymentMethod() %></td>
              <td><span class="<%= "paid".equals(b.getStatus()) ? "s-paid" : "s-pend" %>"><%= b.getStatus() %></span></td>
              <td><form action="billing" method="post" style="display:inline;"><input type="hidden" name="action" value="delete"/><input type="hidden" name="billingId" value="<%= b.getId() %>"/><button type="submit" class="del-btn" onclick="return confirm('Delete?')">Delete</button></form></td>
            </tr>
            <% } %>
            <% if (billings.isEmpty()) { %><tr><td colspan="6" style="text-align:center;color:var(--muted);padding:24px;">No payments yet.</td></tr><% } %>
          </tbody>
        </table>
      </div>
      <% } else { %>
      <div class="card">
        <div class="card-hdr"><div class="card-title"><div class="card-ico">🧾</div>Receipt Preview</div></div>
        <div class="card-body">
          <div style="background:#f8fafc;border:1.5px solid var(--border);border-radius:12px;padding:20px;">
            <div style="text-align:center;padding-bottom:14px;border-bottom:1px dashed #ccc;margin-bottom:14px;"><div style="font-size:20px;font-weight:800;">ParkSmart</div><div style="font-size:12px;color:var(--muted);">Official Parking Receipt</div></div>
            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px;"><span style="color:var(--muted);">Customer</span><strong><%= bName %></strong></div>
            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px;"><span style="color:var(--muted);">Vehicle</span><strong id="prev_v"><%= hasVehicle ? userVehicleNo : "—" %></strong></div>
            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px;"><span style="color:var(--muted);">Date</span><strong><%= billDate %></strong></div>
            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px;"><span style="color:var(--muted);">Hours</span><strong id="prev_h">—</strong></div>
            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px;"><span style="color:var(--muted);">Method</span><strong id="prev_m">Cash</strong></div>
            <div style="display:flex;justify-content:space-between;padding:12px 0 0;font-size:18px;font-weight:700;border-top:2px solid #0f172a;margin-top:8px;"><span>Total</span><span id="prev_t" style="color:#6366f1;">Rs. 0.00</span></div>
          </div>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</div>

<!-- PRINTABLE RECEIPT — hidden on screen, visible only when printing -->
<div id="receiptArea">
  <div class="receipt">
    <div class="r-hdr">
      <div class="r-logo">ParkSmart</div>
      <div class="r-sub">Vehicle Parking Management System</div>
      <div class="r-tag">Official Parking Receipt</div>
    </div>
    <div class="r-row"><span class="r-key">Receipt No.</span><span class="r-val">#<%= String.format("%04d", receiptNo) %></span></div>
    <div class="r-row"><span class="r-key">Date</span><span class="r-val"><%= billDate %></span></div>
    <div class="r-row"><span class="r-key">Time</span><span class="r-val"><%= billTime %></span></div>
    <div class="r-row"><span class="r-key">Customer Name</span><span class="r-val"><%= bName %></span></div>
    <div class="r-row"><span class="r-key">Vehicle Number</span><span class="r-val" id="r_vehicle"><%= hasVehicle ? userVehicleNo : "—" %></span></div>
    <div class="r-row"><span class="r-key">Hours Parked</span><span class="r-val" id="r_hours">—</span></div>
    <div class="r-row"><span class="r-key">Rate per Hour</span><span class="r-val">Rs. 100.00</span></div>
    <div class="r-row"><span class="r-key">Payment Method</span><span class="r-val" id="r_method">Cash</span></div>
    <div class="r-total"><span>Total Amount</span><span id="r_total">Rs. 0.00</span></div>
    <div class="r-foot">Thank you for using ParkSmart!<br/>Please keep this receipt for your records.<br/><strong>parksmart.lk</strong></div>
  </div>
</div>

<script>
const lockedV = '<%= hasVehicle ? userVehicleNo : "" %>';
function getV() {
  if (lockedV) return lockedV;
  const el = document.getElementById('f_vehicle');
  return el ? el.value.trim() : '';
}
function update() {
  const v = getV() || '—';
  const h = parseInt(document.getElementById('f_hours').value) || 0;
  const m = document.getElementById('f_method').value;
  const t = 'Rs. ' + (h * 100).toFixed(2);
  // Summary
  document.getElementById('p_vehicle').textContent = v;
  document.getElementById('p_hours').textContent   = h + ' hour(s)';
  document.getElementById('p_method').textContent  = m;
  document.getElementById('p_total').textContent   = t;
  // Preview
  const pv=document.getElementById('prev_v'), ph=document.getElementById('prev_h'),
        pm=document.getElementById('prev_m'), pt=document.getElementById('prev_t');
  if(pv) pv.textContent=v; if(ph) ph.textContent=h+' hour(s)';
  if(pm) pm.textContent=m; if(pt) pt.textContent=t;
  // Receipt
  document.getElementById('r_vehicle').textContent = v;
  document.getElementById('r_hours').textContent   = h + ' hour(s)';
  document.getElementById('r_method').textContent  = m;
  document.getElementById('r_total').textContent   = t;
}
function saveAndPrint() {
  const v = getV();
  const h = parseInt(document.getElementById('f_hours').value) || 0;
  const m = document.getElementById('f_method').value;
  if (!v) { alert('Please enter the vehicle number!'); return; }
  if (h < 1) { alert('Please enter hours parked!'); document.getElementById('f_hours').focus(); return; }
  update();
  window.print();
  setTimeout(function() {
    const f = document.createElement('form');
    f.method = 'POST'; f.action = 'billing'; f.style.display = 'none';
    [['vehicleNo',v],['hours',h],['paymentMethod',m],['customerName','<%= bName %>']].forEach(([n,val])=>{
      const i=document.createElement('input'); i.type='hidden'; i.name=n; i.value=val; f.appendChild(i);
    });
    document.body.appendChild(f); f.submit();
  }, 800);
}
update();
</script>
</body>
</html>
