<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>VPMS — Vehicle Parking Management System</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --bg: #F4F6FB;
      --surface: #FFFFFF;
      --surface2: #EEF1F8;
      --navy: #1A2340;
      --navy-mid: #2D3A5E;
      --accent: #4F6EF7;
      --accent-light: #E8ECFF;
      --green: #22C55E;
      --green-light: #DCFCE7;
      --amber: #F59E0B;
      --amber-light: #FEF3C7;
      --red: #EF4444;
      --red-light: #FEE2E2;
      --text: #1A2340;
      --text-muted: #6B7A99;
      --border: #DDE3F0;
      --shadow: 0 2px 16px rgba(26,35,64,0.07);
      --shadow-md: 0 6px 32px rgba(26,35,64,0.12);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'DM Sans', sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
    }

    /* ── SIDEBAR ── */
    .sidebar {
      width: 240px;
      background: var(--navy);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      position: fixed;
      top: 0; left: 0; bottom: 0;
      z-index: 100;
    }

    .sidebar-logo {
      padding: 28px 24px 20px;
      border-bottom: 1px solid rgba(255,255,255,0.08);
    }
    .sidebar-logo .logo-mark {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .logo-icon {
      width: 36px; height: 36px;
      background: var(--accent);
      border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: 18px;
    }
    .logo-text {
      font-family: 'Space Mono', monospace;
      font-size: 15px;
      font-weight: 700;
      color: #fff;
      letter-spacing: -0.3px;
    }
    .logo-sub {
      font-size: 10px;
      color: rgba(255,255,255,0.4);
      font-family: 'Space Mono', monospace;
      margin-top: 1px;
    }

    .sidebar-section {
      padding: 20px 16px 6px;
    }
    .sidebar-section-label {
      font-size: 10px;
      font-weight: 600;
      letter-spacing: 1.2px;
      color: rgba(255,255,255,0.3);
      text-transform: uppercase;
      padding: 0 8px;
      margin-bottom: 6px;
    }

    .nav-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 12px;
      border-radius: 8px;
      cursor: pointer;
      color: rgba(255,255,255,0.55);
      font-size: 14px;
      font-weight: 500;
      transition: all 0.18s;
      margin-bottom: 2px;
      text-decoration: none;
    }
    .nav-item:hover { background: rgba(255,255,255,0.08); color: #fff; }
    .nav-item.active {
      background: var(--accent);
      color: #fff;
      box-shadow: 0 4px 12px rgba(79,110,247,0.35);
    }
    .nav-icon { font-size: 16px; width: 20px; text-align: center; }

    .sidebar-footer {
      margin-top: auto;
      padding: 16px;
      border-top: 1px solid rgba(255,255,255,0.08);
    }
    .user-badge {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 12px;
      background: rgba(255,255,255,0.06);
      border-radius: 10px;
    }
    .user-avatar {
      width: 34px; height: 34px;
      border-radius: 50%;
      background: var(--accent);
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; font-size: 13px; color: #fff;
    }
    .user-name { font-size: 13px; font-weight: 600; color: #fff; }
    .user-role { font-size: 11px; color: rgba(255,255,255,0.4); }
    .logout-btn {
      margin-left: auto;
      color: rgba(255,255,255,0.3);
      font-size: 16px;
      cursor: pointer;
      transition: color 0.15s;
    }
    .logout-btn:hover { color: var(--red); }

    /* ── MAIN ── */
    .main {
      margin-left: 240px;
      flex: 1;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* ── TOPBAR ── */
    .topbar {
      background: var(--surface);
      border-bottom: 1px solid var(--border);
      padding: 16px 32px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      position: sticky; top: 0; z-index: 50;
    }
    .topbar-title h1 { font-size: 20px; font-weight: 700; }
    .topbar-title p { font-size: 13px; color: var(--text-muted); margin-top: 1px; }
    .topbar-actions { display: flex; gap: 10px; align-items: center; }
    .btn {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      padding: 9px 18px;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      border: none;
      transition: all 0.18s;
      font-family: 'DM Sans', sans-serif;
    }
    .btn-outline {
      background: transparent;
      border: 1.5px solid var(--border);
      color: var(--text);
    }
    .btn-outline:hover { border-color: var(--accent); color: var(--accent); }
    .btn-primary {
      background: var(--accent);
      color: #fff;
      box-shadow: 0 4px 12px rgba(79,110,247,0.25);
    }
    .btn-primary:hover { background: #3d5ae0; }
    .status-dot {
      width: 7px; height: 7px;
      border-radius: 50%;
      background: var(--green);
      box-shadow: 0 0 0 3px var(--green-light);
      display: inline-block;
    }

    /* ── CONTENT ── */
    .content { padding: 28px 32px; flex: 1; }

    /* ── STAT CARDS ── */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: var(--surface);
      border-radius: 14px;
      padding: 20px;
      border: 1.5px solid var(--border);
      box-shadow: var(--shadow);
      display: flex;
      flex-direction: column;
      gap: 12px;
      transition: transform 0.18s, box-shadow 0.18s;
    }
    .stat-card:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
    }
    .stat-header { display: flex; align-items: center; justify-content: space-between; }
    .stat-label { font-size: 12px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.6px; }
    .stat-icon {
      width: 36px; height: 36px;
      border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: 17px;
    }
    .stat-value {
      font-family: 'Space Mono', monospace;
      font-size: 28px;
      font-weight: 700;
      color: var(--text);
      line-height: 1;
    }
    .stat-sub { font-size: 12px; color: var(--text-muted); }
    .stat-badge {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-size: 11px;
      font-weight: 600;
      padding: 3px 8px;
      border-radius: 20px;
    }
    .badge-green { background: var(--green-light); color: #16a34a; }
    .badge-amber { background: var(--amber-light); color: #b45309; }
    .badge-red { background: var(--red-light); color: #dc2626; }
    .badge-blue { background: var(--accent-light); color: var(--accent); }

    /* ── SECTION GRID ── */
    .section-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 24px;
    }

    /* ── CARDS ── */
    .card {
      background: var(--surface);
      border-radius: 14px;
      border: 1.5px solid var(--border);
      box-shadow: var(--shadow);
      overflow: hidden;
    }
    .card-header {
      padding: 18px 20px 14px;
      border-bottom: 1.5px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .card-title {
      font-size: 14px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .card-title-icon {
      width: 28px; height: 28px;
      border-radius: 7px;
      display: flex; align-items: center; justify-content: center;
      font-size: 14px;
      background: var(--accent-light);
    }
    .card-body { padding: 18px 20px; }

    /* ── FORM ── */
    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .form-group { display: flex; flex-direction: column; gap: 6px; }
    .form-group.full { grid-column: 1 / -1; }
    .form-label { font-size: 12px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
    .form-input, .form-select {
      padding: 10px 14px;
      border: 1.5px solid var(--border);
      border-radius: 8px;
      font-size: 13px;
      font-family: 'DM Sans', sans-serif;
      color: var(--text);
      background: var(--bg);
      transition: border-color 0.18s, box-shadow 0.18s;
      outline: none;
    }
    .form-input:focus, .form-select:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(79,110,247,0.1);
    }
    .form-input::placeholder { color: #aab2c8; }
    .form-actions {
      margin-top: 16px;
      display: flex;
      gap: 10px;
      justify-content: flex-end;
    }

    /* ── SLOTS GRID ── */
    .slots-visual {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 10px;
      padding: 4px 0;
    }
    .slot {
      border-radius: 10px;
      padding: 12px 8px;
      text-align: center;
      border: 2px solid;
      transition: transform 0.15s;
      cursor: pointer;
    }
    .slot:hover { transform: scale(1.04); }
    .slot-num {
      font-family: 'Space Mono', monospace;
      font-size: 15px;
      font-weight: 700;
      margin-bottom: 4px;
    }
    .slot-type { font-size: 10px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
    .slot.free { background: var(--green-light); border-color: #86efac; color: #15803d; }
    .slot.occupied { background: var(--red-light); border-color: #fca5a5; color: #b91c1c; }
    .slot.reserved { background: var(--amber-light); border-color: #fcd34d; color: #92400e; }

    /* ── TABLE ── */
    .table-wrap { overflow-x: auto; }
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
    }
    thead th {
      text-align: left;
      padding: 10px 14px;
      font-size: 11px;
      font-weight: 700;
      color: var(--text-muted);
      text-transform: uppercase;
      letter-spacing: 0.8px;
      border-bottom: 1.5px solid var(--border);
      background: var(--bg);
    }
    tbody tr {
      border-bottom: 1px solid var(--border);
      transition: background 0.12s;
    }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: var(--bg); }
    td { padding: 12px 14px; color: var(--text); vertical-align: middle; }
    .vehicle-tag {
      font-family: 'Space Mono', monospace;
      font-size: 12px;
      background: var(--navy);
      color: #fff;
      padding: 3px 9px;
      border-radius: 5px;
      letter-spacing: 0.5px;
    }
    .pill {
      display: inline-flex;
      align-items: center;
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 700;
    }
    .pill-car { background: var(--accent-light); color: var(--accent); }
    .pill-bike { background: var(--amber-light); color: #92400e; }
    .action-btn {
      padding: 5px 12px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 600;
      cursor: pointer;
      border: 1.5px solid var(--border);
      background: transparent;
      color: var(--text-muted);
      transition: all 0.15s;
      font-family: 'DM Sans', sans-serif;
    }
    .action-btn:hover { border-color: var(--red); color: var(--red); }

    /* ── LEGEND ── */
    .legend {
      display: flex;
      gap: 14px;
      padding: 12px 20px;
      border-top: 1.5px solid var(--border);
      background: var(--bg);
    }
    .legend-item { display: flex; align-items: center; gap: 6px; font-size: 12px; color: var(--text-muted); font-weight: 500; }
    .legend-dot { width: 10px; height: 10px; border-radius: 50%; }

    /* ── TAB STRIP ── */
    .tab-strip {
      display: flex;
      gap: 2px;
      padding: 4px;
      background: var(--bg);
      border-radius: 9px;
    }
    .tab {
      padding: 7px 16px;
      border-radius: 7px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
      color: var(--text-muted);
      transition: all 0.15s;
    }
    .tab.active { background: var(--surface); color: var(--text); box-shadow: var(--shadow); }


    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .stat-card { animation: fadeUp 0.4s ease both; }
    .stat-card:nth-child(1) { animation-delay: 0.05s; }
    .stat-card:nth-child(2) { animation-delay: 0.1s; }
    .stat-card:nth-child(3) { animation-delay: 0.15s; }
    .stat-card:nth-child(4) { animation-delay: 0.2s; }
    .card { animation: fadeUp 0.4s ease 0.2s both; }
  </style>
</head>
<body>

<!-- ═══════════ SIDEBAR ═══════════ -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="logo-mark">
      <div class="logo-icon">🅿️</div>
      <div>
        <div class="logo-text">PARKSMART</div>
    </div>
  </div>

  <div class="sidebar-section">
    <div class="sidebar-section-label">Main</div>
    <a class="nav-item active" href="#">
      <span class="nav-icon">⬛</span> Dashboard
    </a>
    <a class="nav-item" href="#">
      <span class="nav-icon">👤</span> User Registration
    </a>
    <a class="nav-item" href="#">
      <span class="nav-icon">🚗</span> Vehicle Registration
    </a>
    <a class="nav-item" href="#">
      <span class="nav-icon">🅿️</span> Parking Slots
    </a>
  </div>

  <div class="sidebar-section">
    <div class="sidebar-section-label">System</div>
    <a class="nav-item" href="#">
      <span class="nav-icon">📋</span> Parking History
    </a>
    <a class="nav-item" href="#">
      <span class="nav-icon">💳</span> Billing
    </a>
    <a class="nav-item" href="#">
      <span class="nav-icon">📊</span> Reports
    </a>
    <a class="nav-item" href="#">
      <span class="nav-icon">⚙️</span> Admin Panel
    </a>
  </div>

  <div class="sidebar-footer">
    <div class="user-badge">
      <div class="user-avatar">S</div>
      <div>
        <div class="user-name">Sesandi</div>
        <div class="user-role">System Admin</div>
      </div>
      <span class="logout-btn" title="Logout">⏏</span>
    </div>
  </div>
</aside>

<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div class="topbar-title">
      <h1>Dashboard</h1>
      <p>Vehicle Parking Management System — Real-time overview</p>
    </div>
    <div class="topbar-actions">
      <button class="btn btn-outline">⬇ Export Report</button>
      <button class="btn btn-primary"><span class="status-dot"></span> System Live</button>
    </div>
  </header>

  <!-- CONTENT -->
  <div class="content">

    <!-- STAT CARDS -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-header">
          <span class="stat-label">Total Users</span>
          <div class="stat-icon" style="background:#EEF1F8;">👥</div>
        </div>
        <div class="stat-value">48</div>
        <div style="display:flex;align-items:center;gap:8px;">
          <span class="stat-badge badge-green">↑ +3 today</span>
          <span class="stat-sub">Registered users</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-header">
          <span class="stat-label">Slots Available</span>
          <div class="stat-icon" style="background:#DCFCE7;">🟢</div>
        </div>
        <div class="stat-value">12</div>
        <div style="display:flex;align-items:center;gap:8px;">
          <span class="stat-badge badge-amber">8 occupied</span>
          <span class="stat-sub">of 20 total</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-header">
          <span class="stat-label">Vehicles Parked</span>
          <div class="stat-icon" style="background:#FEE2E2;">🚗</div>
        </div>
        <div class="stat-value">8</div>
        <div style="display:flex;align-items:center;gap:8px;">
          <span class="stat-badge badge-blue">5 cars · 3 bikes</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-header">
          <span class="stat-label">Revenue Today</span>
          <div class="stat-icon" style="background:#FEF3C7;">💰</div>
        </div>
        <div class="stat-value">Rs.2,450</div>
        <div style="display:flex;align-items:center;gap:8px;">
          <span class="stat-badge badge-green">↑ +12%</span>
          <span class="stat-sub">vs yesterday</span>
        </div>
      </div>
    </div>

    <!-- MIDDLE ROW: User Reg Form + Slot View -->
    <div class="section-grid">

      <!-- USER + VEHICLE REGISTRATION FORM -->
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            <div class="card-title-icon">👤</div>
            Register User &amp; Vehicle
          </div>
          <div class="tab-strip">
            <div class="tab active">User</div>
            <div class="tab">Vehicle</div>
          </div>
        </div>
        <div class="card-body">
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Full Name</label>
              <input class="form-input" type="text" placeholder="e.g. Kasuni Perera"/>
            </div>
            <div class="form-group">
              <label class="form-label">Contact No.</label>
              <input class="form-input" type="text" placeholder="07X XXX XXXX"/>
            </div>
            <div class="form-group">
              <label class="form-label">Username</label>
              <input class="form-input" type="text" placeholder="kasuni2024"/>
            </div>
            <div class="form-group">
              <label class="form-label">Password</label>
              <input class="form-input" type="password" placeholder="••••••••"/>
            </div>
            <div class="form-group">
              <label class="form-label">Vehicle Number</label>
              <input class="form-input" type="text" placeholder="CAR-1234"/>
            </div>
            <div class="form-group">
              <label class="form-label">Vehicle Type</label>
              <select class="form-select">
                <option>Car</option>
                <option>Motorbike</option>
                <option>Van</option>
                <option>Three-Wheeler</option>
              </select>
            </div>
          </div>
          <div class="form-actions">
            <button class="btn btn-outline">Clear</button>
            <button class="btn btn-primary">Register →</button>
          </div>
        </div>
      </div>

      <!-- PARKING SLOT VIEW -->
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            <div class="card-title-icon">🅿️</div>
            Parking Slot Overview
          </div>
          <span class="stat-badge badge-green">12 free</span>
        </div>
        <div class="card-body">
          <div class="slots-visual">
            <div class="slot free"><div class="slot-num">A01</div><div class="slot-type">Free</div></div>
            <div class="slot occupied"><div class="slot-num">A02</div><div class="slot-type">Occupied</div></div>
            <div class="slot free"><div class="slot-num">A03</div><div class="slot-type">Free</div></div>
            <div class="slot reserved"><div class="slot-num">A04</div><div class="slot-type">Reserved</div></div>
            <div class="slot occupied"><div class="slot-num">B01</div><div class="slot-type">Occupied</div></div>
            <div class="slot free"><div class="slot-num">B02</div><div class="slot-type">Free</div></div>
            <div class="slot free"><div class="slot-num">B03</div><div class="slot-type">Free</div></div>
            <div class="slot occupied"><div class="slot-num">B04</div><div class="slot-type">Occupied</div></div>
            <div class="slot free"><div class="slot-num">C01</div><div class="slot-type">Free</div></div>
            <div class="slot free"><div class="slot-num">C02</div><div class="slot-type">Free</div></div>
            <div class="slot reserved"><div class="slot-num">C03</div><div class="slot-type">Reserved</div></div>
            <div class="slot occupied"><div class="slot-num">C04</div><div class="slot-type">Occupied</div></div>
          </div>
        </div>
        <div class="legend">
          <div class="legend-item"><div class="legend-dot" style="background:#22C55E;"></div>Free</div>
          <div class="legend-item"><div class="legend-dot" style="background:#EF4444;"></div>Occupied</div>
          <div class="legend-item"><div class="legend-dot" style="background:#F59E0B;"></div>Reserved</div>
        </div>
      </div>

    </div>

    <!-- BOTTOM: Registered Users Table -->
    <div class="card">
      <div class="card-header">
        <div class="card-title">
          <div class="card-title-icon">📋</div>
          Registered Users &amp; Vehicles
        </div>
        <button class="btn btn-outline" style="font-size:12px;padding:7px 14px;">View All</button>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>User ID</th>
              <th>Name</th>
              <th>Contact</th>
              <th>Vehicle No.</th>
              <th>Vehicle Type</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><code style="font-size:12px;color:var(--text-muted);">#U001</code></td>
              <td><strong>Kasuni Perera</strong></td>
              <td>0771234567</td>
              <td><span class="vehicle-tag">CAR-1234</span></td>
              <td><span class="pill pill-car">Car</span></td>
              <td><span class="stat-badge badge-green">Active</span></td>
              <td><button class="action-btn">Delete</button></td>
            </tr>
            <tr>
              <td><code style="font-size:12px;color:var(--text-muted);">#U002</code></td>
              <td><strong>Amal Fernando</strong></td>
              <td>0712345678</td>
              <td><span class="vehicle-tag">BIK-5678</span></td>
              <td><span class="pill pill-bike">Bike</span></td>
              <td><span class="stat-badge badge-green">Active</span></td>
              <td><button class="action-btn">Delete</button></td>
            </tr>
            <tr>
              <td><code style="font-size:12px;color:var(--text-muted);">#U003</code></td>
              <td><strong>Nimal Silva</strong></td>
              <td>0769876543</td>
              <td><span class="vehicle-tag">VAN-9012</span></td>
              <td><span class="pill pill-car">Van</span></td>
              <td><span class="stat-badge badge-amber">Inactive</span></td>
              <td><button class="action-btn">Delete</button></td>
            </tr>
            <tr>
              <td><code style="font-size:12px;color:var(--text-muted);">#U004</code></td>
              <td><strong>Dilani Jayawardena</strong></td>
              <td>0783214567</td>
              <td><span class="vehicle-tag">CAR-3344</span></td>
              <td><span class="pill pill-car">Car</span></td>
              <td><span class="stat-badge badge-green">Active</span></td>
              <td><button class="action-btn">Delete</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

  </div><!-- /content -->
</div><!-- /main -->

<script>
  // Tab switching for User/Vehicle form
  document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', () => {
      document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
    });
  });

  // Nav item switching
  document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', e => {
      e.preventDefault();
      document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
      item.classList.add('active');
    });
  });
</script>

</body>
</html>
