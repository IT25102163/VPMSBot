package isuru;

import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

/**
 * HistoryServlet - Controller for History & Reports pages
 *
 * Handles:
 *   GET  /history         -> Show history list with search/filter
 *   GET  /history?action=edit&id=X -> Show edit form
 *   POST /history action=delete -> Delete a record
 *   POST /history action=update -> Update a record
 */
@WebServlet("/history")
public class HistoryServlet extends HttpServlet {

    private ParkingHistoryDAO dao = new ParkingHistoryDAO();

    // ═══════════════════════════════════════════
    // GET - Show history page
    // ═══════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // Show edit form for a specific record
        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            ParkingSession session = dao.getSessionById(id);
            req.setAttribute("editSession", session);
            req.getRequestDispatcher("isuru/history.jsp").forward(req, res);
            return;
        }

        // Get search and filter parameters from URL
        String plate    = req.getParameter("plate");
        String status   = req.getParameter("status");
        String dateFrom = req.getParameter("dateFrom");
        String dateTo   = req.getParameter("dateTo");

        // Get filtered or all sessions
        List<ParkingSession> sessions;
        if ((plate != null && !plate.isEmpty()) ||
            (status != null && !status.isEmpty()) ||
            (dateFrom != null && !dateFrom.isEmpty()) ||
            (dateTo != null && !dateTo.isEmpty())) {
            sessions = dao.searchSessions(plate, status, dateFrom, dateTo);
        } else {
            sessions = dao.getAllSessions();
        }

        // Build chart data string for Google Charts
        // Format: ['2025-03-10', 5], ['2025-03-11', 3], ...
        Map<String, Integer> chartData = dao.getDailyVehicleCount();
        StringBuilder chartRows = new StringBuilder();
        for (Map.Entry<String, Integer> entry : chartData.entrySet()) {
            chartRows.append("['").append(entry.getKey())
                     .append("', ").append(entry.getValue()).append("],");
        }

        // Send data to JSP
        req.setAttribute("sessions",  sessions);
        req.setAttribute("chartRows", chartRows.toString());
        req.setAttribute("plate",     plate);
        req.setAttribute("status",    status);
        req.setAttribute("dateFrom",  dateFrom);
        req.setAttribute("dateTo",    dateTo);

        req.getRequestDispatcher("isuru/history.jsp").forward(req, res);
    }

    // ═══════════════════════════════════════════
    // POST - Handle delete and update
    // ═══════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteSession(id);
        }

        if ("update".equals(action)) {
            ParkingSession session = new ParkingSession();
            session.setId(Integer.parseInt(req.getParameter("id")));
            session.setVehiclePlate(req.getParameter("vehicle_plate"));
            session.setSlotNumber(req.getParameter("slot_number"));
            session.setStatus(req.getParameter("status"));
            session.setNotes(req.getParameter("notes"));
            dao.updateSession(session);
        }

        // Redirect back to history page after action
        res.sendRedirect(req.getContextPath() + "/history");
    }
}
