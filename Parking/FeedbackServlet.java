package Parking;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet({"/submitFeedback", "/deleteFeedback", "/editFeedback"})
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Edit feedback — load it into session for the form
        if ("/editFeedback".equals(req.getServletPath())) {
            req.getSession().setAttribute("editFeedbackId", req.getParameter("feedbackId"));
            req.getSession().setAttribute("editFeedbackMsg", req.getParameter("message"));
            req.getSession().setAttribute("editFeedbackRating", req.getParameter("rating"));
        }
        res.sendRedirect("feedback.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        // DELETE
        if ("/deleteFeedback".equals(path)) {
            try { new ParkingLotDAO().deleteFeedback(Integer.parseInt(req.getParameter("feedbackId"))); }
            catch (Exception e) { e.printStackTrace(); }
            res.sendRedirect("feedback.jsp");
            return;
        }

        // UPDATE (edit) feedback message/rating
        if ("/editFeedback".equals(path)) {
            try {
                int    id      = Integer.parseInt(req.getParameter("feedbackId"));
                String message = req.getParameter("message");
                int    rating  = Integer.parseInt(req.getParameter("rating"));
                // Update in DB
                java.sql.Connection conn = DBConnection.getConnection();
                java.sql.PreparedStatement ps = conn.prepareStatement(
                        "UPDATE feedback SET message=?, rating=? WHERE id=?");
                ps.setString(1, message);
                ps.setInt   (2, rating);
                ps.setInt   (3, id);
                ps.executeUpdate();
                conn.close();
                // Clear edit session
                req.getSession().removeAttribute("editFeedbackId");
                req.getSession().removeAttribute("editFeedbackMsg");
                req.getSession().removeAttribute("editFeedbackRating");
                res.sendRedirect("feedback.jsp?success=updated");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect("feedback.jsp?error=true");
            }
            return;
        }

        // SUBMIT NEW FEEDBACK
        try {
            int userId = Integer.parseInt(req.getParameter("userId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            new ParkingLotDAO().saveFeedback(new Feedback(userId, req.getParameter("message"), rating));
            res.sendRedirect("feedback.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("feedback.jsp?error=true");
        }
    }
}
