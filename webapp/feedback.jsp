<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Parking.*" %>
<%
  if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
  String fbName = (String) session.getAttribute("name");
  String fbRole = (String) session.getAttribute("role");
  int fbUserId  = 0;
  try { fbUserId = (int) session.getAttribute("userId"); } catch(Exception e) {}
  if (fbName == null) fbName = "User";
  if (fbRole == null) fbRole = "user";
  boolean isAdmin = "admin".equals(fbRole);

  ParkingLotDAO feedbackDAO = new ParkingLotDAO();
  List<Feedback> feedbacks = new ArrayList<>();
  try { feedbacks = feedbackDAO.getFeedbacks(); } catch(Exception e) {}

  // Check if editing
  String editFbId     = (String) session.getAttribute("editFeedbackId");
  String editFbMsg    = (String) session.getAttribute("editFeedbackMsg");
  String editFbRating = (String) session.getAttribute("editFeedbackRating");
  boolean isEditingFb = editFbId != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>ParkSmart — Feedback</title>
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
.card-hdr{padding:16px 20px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-title{font-size:14px;font-weight:700;display:flex;align-items:center;gap:8px;}
.card-ico{width:28px;height:28px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--accent-light);}
.card-body{padding:20px;}
.form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:13px;}
.form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;}
.form-input,.form-textarea{padding:10px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;outline:none;width:100%;}
.form-input:focus,.form-textarea:focus{border-color:var(--accent);background:#fff;}
.form-input:disabled{background:#f1f5f9;color:var(--text);}
.form-textarea{resize:vertical;min-height:90px;}
.star-row{display:flex;gap:6px;}
.star{font-size:26px;cursor:pointer;color:#e2e8f0;transition:color 0.15s;}
.star.sel,.star:hover{color:var(--amber);}
.btn-submit{background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;}
.btn-save{background:linear-gradient(135deg,#F59E0B,#d97706);color:#fff;border:none;padding:11px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;}
.btn-cancel{background:transparent;border:1.5px solid var(--border);color:var(--muted);padding:10px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;width:100%;text-decoration:none;display:block;text-align:center;margin-bottom:8px;}
.edit-banner{background:#FEF3C7;border:1px solid #fcd34d;border-radius:9px;padding:11px 14px;font-size:13px;color:#92400e;font-weight:600;margin-bottom:14px;}
.alert{padding:11px 15px;border-radius:9px;font-size:13px;margin-bottom:16px;font-weight:500;}
.alert-s{background:var(--green-light);color:#15803d;border:1px solid #86efac;}
.fb-item{padding:14px;border-radius:10px;border:1px solid var(--border);margin-bottom:10px;background:#fafbff;}
.fb-hdr{display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;}
.fb-user{font-size:13px;font-weight:600;}
.fb-stars{color:var(--amber);font-size:15px;}
.fb-msg{font-size:13px;color:var(--muted);line-height:1.5;margin-bottom:8px;}
.fb-actions{display:flex;gap:6px;justify-content:flex-end;}
.del-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer;border:1.5px solid var(--border);background:transparent;color:var(--muted);transition:all 0.15s;font-family:'DM Sans',sans-serif;}
.del-btn:hover{border-color:var(--red);color:var(--red);background:#FEF2F2;}
.edit-btn{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:600;border:1.5px solid #fcd34d;background:#FEF3C7;color:#92400e;text-decoration:none;display:inline-flex;transition:all 0.15s;}
.edit-btn:hover{background:#F59E0B;color:#fff;border-color:#F59E0B;}
.empty{text-align:center;padding:28px;color:var(--muted);font-size:13px;}
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
    <a class="sb-item active" href="feedback.jsp"><div class="sb-ico">💬</div>Feedback</a>
    <a class="sb-item" href="reports.jsp"><div class="sb-ico">📊</div>Reports</a>
    <a class="sb-item" href="staff"><div class="sb-ico">👷</div>Staff Management</a>
    <a class="sb-item" href="admin"><div class="sb-ico">⚙️</div>Admin Panel</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="sb-av"><%= fbName.substring(0,1).toUpperCase() %></div>
      <div><div class="sb-uname"><%= fbName %></div><div class="sb-urole"><%= fbRole %></div></div>
    </div>
  </div>
</aside>

<div class="main">
  <header class="topbar">
    <div class="tb-left"><h1>Feedback</h1><p>Submit and manage parking feedback</p></div>
    <a href="logout" class="btn-logout">⏏ Logout</a>
  </header>
  <div class="content">
    <% if ("true".equals(request.getParameter("success")) || "updated".equals(request.getParameter("success"))) { %>
    <div class="alert alert-s">✅ Feedback <%= "updated".equals(request.getParameter("success")) ? "updated" : "submitted" %> successfully!</div>
    <% } %>
    <div class="layout">

      <!-- FORM — switches between submit and edit mode -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title"><div class="card-ico"><%= isEditingFb ? "✏️" : "💬" %></div><%= isEditingFb ? "Edit Feedback" : "Submit Feedback" %></div>
          <% if (isEditingFb) { %><a href="feedback.jsp" class="edit-btn" style="font-size:12px;padding:5px 10px;">← Cancel</a><% } %>
        </div>
        <div class="card-body">
          <% if (isEditingFb) { %>
          <div class="edit-banner">✏️ Editing feedback #<%= editFbId %></div>
          <form action="editFeedback" method="post">
            <input type="hidden" name="feedbackId" value="<%= editFbId %>"/>
            <div class="form-group">
              <label class="form-label">Message</label>
              <textarea class="form-textarea" name="message" required><%= editFbMsg != null ? editFbMsg : "" %></textarea>
            </div>
            <div class="form-group">
              <label class="form-label">Rating</label>
              <div class="star-row" id="editStarRow">
                <% int eRating = editFbRating != null ? Integer.parseInt(editFbRating) : 5; %>
                <% for (int i=1;i<=5;i++) { %>
                <span class="star <%= i<=eRating ? "sel" : "" %>" onclick="setEditRating(<%= i %>)">★</span>
                <% } %>
              </div>
              <input type="hidden" name="rating" id="editRatingVal" value="<%= eRating %>"/>
            </div>
            <button type="submit" class="btn-save">Save Changes →</button>
          </form>

          <% } else { %>
          <form action="submitFeedback" method="post">
            <input type="hidden" name="userId" value="<%= fbUserId %>"/>
            <div class="form-group">
              <label class="form-label">Your Name</label>
              <input class="form-input" type="text" value="<%= fbName %>" disabled/>
            </div>
            <div class="form-group">
              <label class="form-label">Message</label>
              <textarea class="form-textarea" name="message" placeholder="Share your experience..." required></textarea>
            </div>
            <div class="form-group">
              <label class="form-label">Rating</label>
              <div class="star-row">
                <span class="star sel" onclick="setRating(1)">★</span>
                <span class="star sel" onclick="setRating(2)">★</span>
                <span class="star sel" onclick="setRating(3)">★</span>
                <span class="star sel" onclick="setRating(4)">★</span>
                <span class="star sel" onclick="setRating(5)">★</span>
              </div>
              <input type="hidden" name="rating" id="ratingVal" value="5"/>
            </div>
            <button type="submit" class="btn-submit">Submit Feedback →</button>
          </form>
          <% } %>
        </div>
      </div>

      <!-- FEEDBACK LIST — admin gets Edit + Delete -->
      <div class="card">
        <div class="card-hdr">
          <div class="card-title"><div class="card-ico">📋</div>All Feedback</div>
          <span style="font-size:12px;color:var(--muted);"><%= feedbacks.size() %> entries</span>
        </div>
        <div class="card-body">
          <% if (feedbacks.isEmpty()) { %>
          <div class="empty">No feedback yet. Be the first!</div>
          <% } else { for (Feedback f : feedbacks) {
            String stars = "";
            for (int i=0;i<f.getRating();i++) stars += "★";
          %>
          <div class="fb-item">
            <div class="fb-hdr">
              <span class="fb-user">User #<%= String.format("%03d", f.getUserId()) %></span>
              <span class="fb-stars"><%= stars %></span>
            </div>
            <div class="fb-msg"><%= f.getMessage() %></div>
            <% if (isAdmin) { %>
            <div class="fb-actions">
              <a href="editFeedback?feedbackId=<%= f.getId() %>&message=<%= java.net.URLEncoder.encode(f.getMessage(),"UTF-8") %>&rating=<%= f.getRating() %>" class="edit-btn">Edit</a>
              <form action="deleteFeedback" method="post" style="display:inline;">
                <input type="hidden" name="feedbackId" value="<%= f.getId() %>"/>
                <button type="submit" class="del-btn" onclick="return confirm('Delete?')">Delete</button>
              </form>
            </div>
            <% } %>
          </div>
          <% } } %>
        </div>
      </div>

    </div>
  </div>
</div>
<script>
function setRating(v) {
  document.getElementById('ratingVal').value = v;
  document.querySelectorAll('.star-row .star').forEach((s,i) => s.classList.toggle('sel', i < v));
}
function setEditRating(v) {
  document.getElementById('editRatingVal').value = v;
  document.querySelectorAll('#editStarRow .star').forEach((s,i) => s.classList.toggle('sel', i < v));
}
setRating(5);
</script>
</body>
</html>
