package Parking;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/history")
public class HistoryServlet extends HttpServlet {

    private ParkingHistoryDAO dao = new ParkingHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // EDIT — load record into form
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                ParkingRecord record = dao.getSessionById(id);
                req.setAttribute("editSession", record);
            } catch (Exception e) { e.printStackTrace(); }
        }

        // SEARCH — read plate and status from URL params
        String plate  = req.getParameter("plate");
        String status = req.getParameter("status");

        List<ParkingRecord> sessions;
        if ((plate != null && !plate.trim().isEmpty()) ||
                (status != null && !status.trim().isEmpty())) {
            sessions = dao.searchSessions(plate, status);
        } else {
            sessions = dao.getAllSessions();
        }

        req.setAttribute("sessions", sessions);
        req.getRequestDispatcher("history.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // DELETE
        if ("delete".equals(action)) {
            try {
                dao.deleteSession(Integer.parseInt(req.getParameter("id")));
            } catch (Exception e) { e.printStackTrace(); }
            res.sendRedirect(req.getContextPath() + "/history");
            return;
        }

        // UPDATE
        if ("update".equals(action)) {
            try {
                ParkingRecord r = new ParkingRecord();
                r.setId          (Integer.parseInt(req.getParameter("id")));
                r.setVehiclePlate(req.getParameter("vehiclePlate"));
                r.setSlotNumber  (req.getParameter("slotNumber"));
                r.setStatus      (req.getParameter("paymentStatus"));
                dao.updateSession(r);
                res.sendRedirect(req.getContextPath() + "/history?updated=true");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect(req.getContextPath() + "/history");
            }
            return;
        }

        res.sendRedirect(req.getContextPath() + "/history");
    }
}
