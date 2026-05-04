package Parking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParkingHistoryDAO {

    // GET ALL
    public List<ParkingRecord> getAllSessions() {
        List<ParkingRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM parking_history ORDER BY history_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRecord(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // SEARCH (by plate and/or status)
    public List<ParkingRecord> searchSessions(String plate, String status) {
        List<ParkingRecord> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM parking_history WHERE 1=1");

        if (plate != null && !plate.trim().isEmpty())
            sql.append(" AND UPPER(vehicle_no) LIKE UPPER(?)");
        if (status != null && !status.trim().isEmpty())
            sql.append(" AND payment_status = ?");
        sql.append(" ORDER BY history_id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (plate != null && !plate.trim().isEmpty())
                ps.setString(i++, "%" + plate.trim() + "%");
            if (status != null && !status.trim().isEmpty())
                ps.setString(i++, status.trim());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRecord(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // GET BY ID
    public ParkingRecord getSessionById(int id) {
        String sql = "SELECT * FROM parking_history WHERE history_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRecord(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // UPDATE
    public void updateSession(ParkingRecord r) {
        String sql = "UPDATE parking_history SET vehicle_no=?, slot_id=?, payment_status=? WHERE history_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getVehiclePlate());
            ps.setString(2, r.getSlotNumber());
            ps.setString(3, r.getStatus());
            ps.setInt   (4, r.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // DELETE
    public void deleteSession(int id) {
        String sql = "DELETE FROM parking_history WHERE history_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // MAP ROW TO OBJECT
    private ParkingRecord mapRecord(ResultSet rs) throws SQLException {
        ParkingRecord r = new ParkingRecord();
        r.setId          (rs.getInt   ("history_id"));
        r.setVehiclePlate(rs.getString("vehicle_no"));
        r.setSlotNumber  (String.valueOf(rs.getInt("slot_id")));
        r.setDurationMins(rs.getLong  ("duration") * 60);
        r.setStatus      (rs.getString("payment_status"));
        Timestamp entry = rs.getTimestamp("entry_time");
        Timestamp exit  = rs.getTimestamp("exit_time");
        if (entry != null) r.setEntryTime(entry.toLocalDateTime());
        if (exit  != null) r.setExitTime (exit.toLocalDateTime());
        return r;
    }
}
