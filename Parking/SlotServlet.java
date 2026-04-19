package Parking;

import java.io.IOException;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * SlotServlet.java — FULLY DATABASE DRIVEN
 * No more hardcoded lists!
 * GET  /slots           → reads ALL slots from parking_slots table
 * POST /slots add       → inserts new slot into DB
 * POST /slots update    → updates slot status in DB (green/yellow/red)
 * POST /slots delete    → deletes slot from DB
 */
@WebServlet("/slots")
public class SlotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Always read fresh from database
        ParkingSlotDAO dao = new ParkingSlotDAO();
        List<ParkingSlot> slots = dao.getAllSlots();
        req.setAttribute("slots", slots);
        req.getRequestDispatcher("view-slots.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // ── ADD NEW SLOT ────────────────────
        if ("add".equals(action)) {
            String slotName = req.getParameter("slotName");
            String status   = req.getParameter("status");
            if (slotName == null || slotName.trim().isEmpty()) {
                res.sendRedirect("slots");
                return;
            }
            if (status == null || status.isEmpty()) status = "Available";
            slotName = slotName.trim().toUpperCase();

            String sql = "INSERT INTO parking_slots (slot_name, status, floor) VALUES (?, ?, 1)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, slotName);
                ps.setString(2, status);
                ps.executeUpdate();
                System.out.println("[SlotServlet] Added slot: " + slotName);
            } catch (SQLException e) {
                System.err.println("[SlotServlet] Error adding slot: " + e.getMessage());
                e.printStackTrace();
            }
            res.sendRedirect("slots");
            return;
        }

        // ── UPDATE SLOT STATUS ──────────────
        // Changes colour: Available=green, Occupied=red, Reserved=yellow
        if ("update".equals(action)) {
            try {
                int    slotId = Integer.parseInt(req.getParameter("id"));
                String status = req.getParameter("status");
                String sql = "UPDATE parking_slots SET status = ? WHERE slot_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, status);
                    ps.setInt   (2, slotId);
                    ps.executeUpdate();
                    System.out.println("[SlotServlet] Updated slot " + slotId + " to " + status);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            res.sendRedirect("slots");
            return;
        }

        // ── DELETE SLOT ─────────────────────
        if ("delete".equals(action)) {
            try {
                int slotId = Integer.parseInt(req.getParameter("id"));
                String sql = "DELETE FROM parking_slots WHERE slot_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, slotId);
                    ps.executeUpdate();
                    System.out.println("[SlotServlet] Deleted slot " + slotId);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            res.sendRedirect("slots");
            return;
        }

        res.sendRedirect("slots");
    }
}
