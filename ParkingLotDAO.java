package Parking;

import java.sql.*;
import java.util.*;

public class ParkingLotDAO {

    // VEHICLE ENTRY
    public boolean recordEntry(String vehicleNo, int userId, int slotId) {
        String sql = "INSERT INTO parking_history (vehicle_no, user_id, slot_id, entry_time, payment_status) VALUES (?, ?, ?, NOW(), 'pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicleNo);
            ps.setInt   (2, userId);
            ps.setInt   (3, slotId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // VEHICLE EXIT
    public boolean recordExit(String vehicleNo, double totalFee) {
        String sql = "UPDATE parking_history SET exit_time=NOW(), duration=TIMESTAMPDIFF(HOUR,entry_time,NOW()), total_fee=?, payment_status='paid' WHERE vehicle_no=? AND exit_time IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, totalFee);
            ps.setString(2, vehicleNo);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Calculating the Bill — Rs.100 per hour
    public double calculateBill(int hours) { return hours * 100.0; }
    // Save Billing
    public void saveBilling(Billing billing) {
        String sql = "INSERT INTO payments (vehicle_no, amount, method, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, billing.getVehicleNo());
            ps.setDouble(2, billing.getAmount());
            ps.setString(3, billing.getPaymentMethod());
            ps.setString(4, billing.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Get all the Billings
    public List<Billing> getBillings() {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Billing(
                        rs.getInt("id"), rs.getString("vehicle_no"),
                        rs.getDouble("amount"), rs.getString("method"), rs.getString("status")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    // Delete Billing NEW
    public boolean deleteBilling(int id) {
        String sql = "DELETE FROM payments WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Update status of billing— NEW
    public boolean updateBillingStatus(int id, String status) {
        String sql = "UPDATE payments SET status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    // Save Feedback
    public void saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (user_id, message, rating) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt   (1, feedback.getUserId());
            ps.setString(2, feedback.getMessage());
            ps.setInt   (3, feedback.getRating());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
    // Get all feedbacks
    public List<Feedback> getFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Feedback(
                        rs.getInt("id"), rs.getInt("user_id"),
                        rs.getString("message"), rs.getInt("rating")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    // Delete Feedback
    public boolean deleteFeedback(int id) {
        String sql = "DELETE FROM feedback WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
