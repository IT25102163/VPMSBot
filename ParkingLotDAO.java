package Billing;

import com.parksmart.Payment.model.Payment;
import com.parksmart.Payment.model.Feedback;
import com.parksmart.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParkingLotDAO {

    // ===== Generate Bill =====
    public double calculateBill(int hours) {
        double ratePerHour = 100.0; // LKR example
        return hours * ratePerHour;
    }

    // ===== Save Payment =====
    public void savePayment(Payment payment) {
        String sql = "INSERT INTO payments(vehicle_id, amount, method, status) VALUES(?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, payment.getVehicleId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getStatus());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===== Get All Payments =====
    public List<Payment> getPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(new Payment(
                        rs.getInt("id"),
                        rs.getInt("vehicle_id"),
                        rs.getDouble("amount"),
                        rs.getString("method"),
                        rs.getString("status")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===== Save Feedback =====
    public void saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback(user_id, message, rating) VALUES(?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedback.getUserId());
            ps.setString(2, feedback.getMessage());
            ps.setInt(3, feedback.getRating());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===== Get Feedback =====
    public List<Feedback> getFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(new Feedback(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("message"),
                        rs.getInt("rating")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
