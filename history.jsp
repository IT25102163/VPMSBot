<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parking History & Reports</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Charts -->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <style>
        body { background-color: #f0f4f8; }
        .navbar { background-color: #1a3c5e; }
        .card { border: none; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .page-title { color: #1a3c5e; font-weight: 700; }
        .stat-card { background: linear-gradient(135deg, #1a3c5e, #2e6da4); color: white; border-radius: 12px; padding: 20px; }
        .table thead { background-color: #1a3c5e; color: white; }
        .btn-primary { background-color: #1a3c5e; border-color: #1a3c5e; }
        .btn-primary:hover { background-color: #2e6da4; border-color: #2e6da4; }
    </style>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-dark px-4 py-3">
    <span class="navbar-brand fw-bold fs-5">🚗 ParkSmart — History & Reports</span>
    <div>
        <a href="../home.jsp" class="btn btn-outline-light btn-sm me-2">Home</a>
        <a href="../admin/dashboard.jsp" class="btn btn-outline-light btn-sm">Admin Dashboard</a>
    </div>
</nav>

<div class="container-fluid py-4 px-4">

    <!-- Page Title -->
    <h3 class="page-title mb-4">📋 Parking History & Reports</h3>

    <!-- ═══ SUMMARY STATS ═══ -->
    <%
        List<ParkingSession> sessions =
            (List<ParkingSession>) request.getAttribute("sessions");
        if (sessions == null) sessions = new ArrayList<>();

        int total     = sessions.size();
        int active    = 0;
        int completed = 0;
        for (ParkingSession s : sessions) {
            if ("ACTIVE".equals(s.getStatus()))    active++;
            if ("COMPLETED".equals(s.getStatus())) completed++;
        }
    %>
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="fs-2 fw-bold"><%= total %></div>
                <div>Total Records</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #198754, #20c997);">
                <div class="fs-2 fw-bold"><%= active %></div>
                <div>Currently Parked</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #0d6efd, #6610f2);">
                <div class="fs-2 fw-bold"><%= completed %></div>
                <div>Completed</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #fd7e14, #dc3545);">
                <div class="fs-2 fw-bold"><%= total - active - completed %></div>
                <div>Cancelled</div>
            </div>
        </div>
    </div>

    <!-- ═══ BAR CHART (Google Charts) ═══ -->
    <div class="card mb-4">
        <div class="card-body">
            <h5 class="card-title fw-bold text-primary">📊 Vehicles Parked — Last 7 Days</h5>
            <div id="chart_div" style="width:100%; height:300px;"></div>
        </div>
    </div>

    <!-- ═══ SEARCH AND FILTER ═══ -->
    <div class="card mb-4">
        <div class="card-body">
            <h5 class="card-title fw-bold">🔍 Search & Filter</h5>
            <form method="get" action="<%= request.getContextPath() %>/history">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Vehicle Plate</label>
                        <input type="text" name="plate" class="form-control"
                               placeholder="e.g. ABC-1234"
                               value="<%= request.getAttribute("plate") != null ? request.getAttribute("plate") : "" %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="">All</option>
                            <option value="ACTIVE"    <%= "ACTIVE".equals(request.getAttribute("status"))    ? "selected" : "" %>>Active</option>
                            <option value="COMPLETED" <%= "COMPLETED".equals(request.getAttribute("status")) ? "selected" : "" %>>Completed</option>
                            <option value="CANCELLED" <%= "CANCELLED".equals(request.getAttribute("status")) ? "selected" : "" %>>Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Date From</label>
                        <input type="date" name="dateFrom" class="form-control"
                               value="<%= request.getAttribute("dateFrom") != null ? request.getAttribute("dateFrom") : "" %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Date To</label>
                        <input type="date" name="dateTo" class="form-control"
                               value="<%= request.getAttribute("dateTo") != null ? request.getAttribute("dateTo") : "" %>">
                    </div>
                    <div class="col-md-3 d-flex align-items-end gap-2">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="<%= request.getContextPath() %>/history" class="btn btn-outline-secondary">Clear</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- ═══ HISTORY TABLE ═══ -->
    <div class="card">
        <div class="card-body">
            <h5 class="card-title fw-bold">📋 Parking History Records</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Vehicle Plate</th>
                            <th>Slot</th>
                            <th>Entry Time</th>
                            <th>Exit Time</th>
                            <th>Duration</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (sessions.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                No records found.
                            </td>
                        </tr>
                        <% } else {
                            for (ParkingSession s : sessions) { %>
                        <tr>
                            <td><%= s.getId() %></td>
                            <td><strong><%= s.getVehiclePlate() %></strong></td>
                            <td><span class="badge bg-secondary"><%= s.getSlotNumber() %></span></td>
                            <td><%= s.getFormattedEntryTime() %></td>
                            <td><%= s.getFormattedExitTime() %></td>
                            <td><%= s.formatDuration() %></td>
                            <td>
                                <span class="badge bg-<%= s.getStatusBadgeClass() %>">
                                    <%= s.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <!-- Edit Button -->
                                <a href="<%= request.getContextPath() %>/history?action=edit&id=<%= s.getId() %>"
                                   class="btn btn-sm btn-outline-primary">Edit</a>

                                <!-- Delete Button (Admin only) -->
                                <form method="post" action="<%= request.getContextPath() %>/history"
                                      style="display:inline;"
                                      onsubmit="return confirm('Delete this record?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= s.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ═══ EDIT FORM (shows only when editing) ═══ -->
    <%
        ParkingSession editSession =
            (ParkingSession) request.getAttribute("editSession");
        if (editSession != null) {
    %>
    <div class="card mt-4">
        <div class="card-body">
            <h5 class="card-title fw-bold text-warning">✏️ Edit Record #<%= editSession.getId() %></h5>
            <form method="post" action="<%= request.getContextPath() %>/history">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= editSession.getId() %>">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Vehicle Plate</label>
                        <input type="text" name="vehicle_plate" class="form-control"
                               value="<%= editSession.getVehiclePlate() %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Slot Number</label>
                        <input type="text" name="slot_number" class="form-control"
                               value="<%= editSession.getSlotNumber() %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE"    <%= "ACTIVE".equals(editSession.getStatus())    ? "selected" : "" %>>Active</option>
                            <option value="COMPLETED" <%= "COMPLETED".equals(editSession.getStatus()) ? "selected" : "" %>>Completed</option>
                            <option value="CANCELLED" <%= "CANCELLED".equals(editSession.getStatus()) ? "selected" : "" %>>Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Notes</label>
                        <input type="text" name="notes" class="form-control"
                               value="<%= editSession.getNotes() != null ? editSession.getNotes() : "" %>">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-warning w-100">Update</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <% } %>

</div><!-- end container -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- ═══ GOOGLE CHARTS SCRIPT ═══ -->
<script type="text/javascript">
    google.charts.load('current', {'packages': ['corechart']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Date');
        data.addColumn('number', 'Vehicles Parked');

        // Chart data from Java Servlet (last 7 days)
        data.addRows([ ${chartRows} ]);

        var options = {
            title: 'Daily Vehicle Count — Last 7 Days',
            hAxis: { title: 'Date' },
            vAxis: { title: 'Number of Vehicles', minValue: 0 },
            colors: ['#1a3c5e'],
            legend: { position: 'none' },
            chartArea: { width: '80%', height: '70%' }
        };

        var chart = new google.visualization.ColumnChart(
            document.getElementById('chart_div')
        );
        chart.draw(data, options);
    }
</script>

</body>
</html>
