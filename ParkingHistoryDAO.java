package isuru;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * ParkingHistoryDAO - Database Access Object for History & Reports
 *
 * OOP Concepts:
 *   ENCAPSULATION : All SQL logic hidden from Servlet
 *   ABSTRACTION   : Servlet only calls named methods, not raw SQL
 *
 * CRUD Operations:
 *   CREATE - addSession()
 *   READ   - getAllSessions(), searchSessions(), getSessionById()
 *   UPDATE - updateSession()
 *   DELETE - deleteSession()
 */
public class ParkingHistoryDAO {

    // ═══════════════════════════════════════════
    // CREATE
    // ═══════════════════════════════════════════

    public boolean addSession(ParkingSession session) {
        String sql = "INSERT INTO parking_sessions " +
                     "(vehicle_plate, slot_number, entry_time, exit_time, duration_mins, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, session.getVehiclePlate().toUpperCase());
            ps.setString(2, session.getSlotNumber().toUpperCase());
            ps.setTimestamp(3, session.getEntryTime() != null ?
                    Timestamp.valueOf(session.getEntryTime()) : null);
            ps.setTimestamp(4, session.getExitTime() != null ?
                    Timestamp.valueOf(session.getExitTime()) : null);
            ps.setLong(5, session.getDurationMins());
            ps.setString(6, session.getStatus() != null ? session.getStatus() : "ACTIVE");
            ps.setString(7, session.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("addSession error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeQuietly(conn);
        }
    }

    // ═══════════════════════════════════════════
    // READ - Get All Sessions
    // ═══════════════════════════════════════════

    public List<ParkingSession> getAllSessions() {
        List<ParkingSession> list = new ArrayList<>();
        String sql = "SELECT * FROM parking_sessions ORDER BY entry_time DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                list.add(mapSession(rs));
            }
        } catch (SQLException e) {
            System.err.println("getAllSessions error: " + e.getMessage());
        } finally {
            DBConnection.closeQuietly(conn);
        }
        return list;
    }

    // READ - Get Single Session by ID
    public ParkingSession getSessionById(int id) {
        String sql = "SELECT * FROM parking_sessions WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapSession(rs);
        } catch (SQLException e) {
            System.err.println("getSessionById error: " + e.getMessage());
        } finally {
            DBConnection.closeQuietly(conn);
        }
        return null;
    }

    // ═══════════════════════════════════════════
    // READ - Search and Filter (for Charya's request)
    // ═══════════════════════════════════════════

    /**
     * Dynamic search with optional filters.
     * "WHERE 1=1" trick allows safely appending AND conditions.
     */
    public List<ParkingSession> searchSessions(String plate, String status,
                                                String dateFrom, String dateTo) {
        List<ParkingSession> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM parking_sessions WHERE 1=1");

        if (plate != null && !plate.trim().isEmpty())
            sql.append(" AND vehicle_plate LIKE ?");
        if (status != null && !status.trim().isEmpty())
            sql.append(" AND status = ?");
        if (dateFrom != null && !dateFrom.trim().isEmpty())
            sql.append(" AND DATE(entry_time) >= ?");
        if (dateTo != null && !dateTo.trim().isEmpty())
            sql.append(" AND DATE(entry_time) <= ?");

        sql.append(" ORDER BY entry_time DESC");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int i = 1;
            if (plate != null && !plate.trim().isEmpty())
                ps.setString(i++, "%" + plate.trim() + "%");
            if (status != null && !status.trim().isEmpty())
                ps.setString(i++, status.trim());
            if (dateFrom != null && !dateFrom.trim().isEmpty())
                ps.setString(i++, dateFrom.trim());
            if (dateTo != null && !dateTo.trim().isEmpty())
                ps.setString(i++, dateTo.trim());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapSession(rs));
        } catch (SQLException e) {
            System.err.println("searchSessions error: " + e.getMessage());
        } finally {
            DBConnection.closeQuietly(conn);
        }
        return list;
    }

    // ═══════════════════════════════════════════
    // READ - Payment Records
    // ═══════════════════════════════════════════

    public List<PaymentRecord> getAllPayments() {
        List<PaymentRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM payment_records ORDER BY payment_time DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) list.add(mapPayment(rs));
        } catch (SQLException e) {
            System.err.println("getAllPayments error: " + e.getMessage());
        } finally {
            DBConnection.closeQuietly(conn);
        }
        return list;
    }

    // ═══════════════════════════════════════════
    // READ - Chart Data (for Google Charts bar chart)
    // ═══════════════════════════════════════════

    /**
     * Returns vehicle count per day for the last 7 days.
     * Used by the bar chart on history.jsp
     * Returns: {"2025-03-10" -> 5, "2025-03-11" -> 3, ...}
     */
    public Map<String, Integer> getDailyVehicleCount() {
        Map<String, Integer> data = new LinkedHashMap<>();
        String sql = "SELECT DATE(entry_time) as day, COUNT(*) as total " +
                     "FROM parking_sessions " +
                     "WHERE entry_time >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                     "GROUP BY DATE(entry_time) ORDER BY day ASC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                data.put(rs.getString("day"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.err.println("getDailyVehicleCount error: " + e.getMessage());
        } finally {
            DBConnection.closeQuietly(conn);
        }
        return data;
    }

    // ═══════════════════════════════════════════
    // UPDATE
    // ═══════════════════════════════════════════

    public boolean updateSession(ParkingSession session) {
        String sql = "UPDATE parking_sessions SET " +
                     "vehicle_plate=?, slot_number=?, entry_time=?, " +
                     "exit_time=?, duration_mins=?, status=?, notes=? " +
                     "WHERE id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, session.getVehiclePlate().toUpperCase());
            ps.setString(2, session.getSlotNumber().toUpperCase());
            ps.setTimestamp(3, session.getEntryTime() != null ?
                    Timestamp.valueOf(session.getEntryTime()) : null);
            ps.setTimestamp(4, session.getExitTime() != null ?
                    Timestamp.valueOf(session.getExitTime()) : null);
            ps.setLong(5, session.getDurationMins());
            ps.setString(6, session.getStatus());
            ps.setString(7, session.getNotes());
            ps.setInt(8, session.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("updateSession error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeQuietly(conn);
        }
    }

    // ═══════════════════════════════════════════
    // DELETE
    // ═══════════════════════════════════════════

    public boolean deleteSession(int id) {
        String sql = "DELETE FROM parking_sessions WHERE id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("deleteSession error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeQuietly(conn);
        }
    }

    // ═══════════════════════════════════════════
    // HELPER - Map ResultSet to Objects
    // ═══════════════════════════════════════════

    private ParkingSession mapSession(ResultSet rs) throws SQLException {
        ParkingSession s = new ParkingSession();
        s.setId(rs.getInt("id"));
        s.setVehiclePlate(rs.getString("vehicle_plate"));
        s.setSlotNumber(rs.getString("slot_number"));
        Timestamp entry = rs.getTimestamp("entry_time");
        Timestamp exit  = rs.getTimestamp("exit_time");
        Timestamp created = rs.getTimestamp("created_at");
        if (entry   != null) s.setEntryTime(entry.toLocalDateTime());
        if (exit    != null) s.setExitTime(exit.toLocalDateTime());
        if (created != null) s.setCreatedAt(created.toLocalDateTime());
        s.setDurationMins(rs.getLong("duration_mins"));
        s.setStatus(rs.getString("status"));
        s.setNotes(rs.getString("notes"));
        return s;
    }

    private PaymentRecord mapPayment(ResultSet rs) throws SQLException {
        PaymentRecord p = new PaymentRecord();
        p.setId(rs.getInt("id"));
        p.setSessionId(rs.getInt("session_id"));
        p.setVehiclePlate(rs.getString("vehicle_plate"));
        p.setAmount(rs.getDouble("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setRatePerHour(rs.getDouble("rate_per_hour"));
        Timestamp pt = rs.getTimestamp("payment_time");
        Timestamp ca = rs.getTimestamp("created_at");
        if (pt != null) p.setPaymentTime(pt.toLocalDateTime());
        if (ca != null) p.setCreatedAt(ca.toLocalDateTime());
        return p;
    }
}
