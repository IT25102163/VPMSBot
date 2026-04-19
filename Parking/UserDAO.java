package Parking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ═══════════════════════════════════════
    // ADD USER
    // ═══════════════════════════════════════
    public void addUser(User user) throws SQLException {
        if (getUserByUsername(user.getUsername()) != null)
            throw new SQLException("USERNAME_EXISTS");
        if (user.getVehicleNo() != null && !user.getVehicleNo().trim().isEmpty())
            if (isVehicleNoExists(user.getVehicleNo().trim()))
                throw new SQLException("VEHICLE_EXISTS");

        String sql = "INSERT INTO users(name,contact,username,password,role,vehicle_no,vehicle_type) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getContact());
            stmt.setString(3, user.getUsername());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getRole() != null ? user.getRole() : "user");
            stmt.setString(6, user.getVehicleNo());
            stmt.setString(7, user.getVehicleType());
            stmt.executeUpdate();
        }
    }

    // ═══════════════════════════════════════
    // UPDATE USER — for edit profile
    // ═══════════════════════════════════════
    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET name=?, contact=?, vehicle_no=?, vehicle_type=? WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getContact());
            stmt.setString(3, user.getVehicleNo());
            stmt.setString(4, user.getVehicleType());
            stmt.setInt   (5, user.getUserId());
            stmt.executeUpdate();
        }
    }

    // ═══════════════════════════════════════
    // CHECK VEHICLE EXISTS
    // ═══════════════════════════════════════
    public boolean isVehicleNoExists(String vehicleNo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE vehicle_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, vehicleNo.toUpperCase());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    // ═══════════════════════════════════════
    // GET ALL USERS
    // ═══════════════════════════════════════
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User u = new User();
                u.setUserId    (rs.getInt   ("user_id"));
                u.setName      (rs.getString("name"));
                u.setContact   (rs.getString("contact"));
                u.setUsername  (rs.getString("username"));
                u.setRole      (rs.getString("role"));
                u.setVehicleNo (rs.getString("vehicle_no"));
                u.setVehicleType(rs.getString("vehicle_type"));
                users.add(u);
            }
        }
        return users;
    }

    // ═══════════════════════════════════════
    // GET USER BY USERNAME
    // ═══════════════════════════════════════
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId    (rs.getInt   ("user_id"));
                u.setName      (rs.getString("name"));
                u.setContact   (rs.getString("contact"));
                u.setUsername  (rs.getString("username"));
                u.setPassword  (rs.getString("password"));
                u.setRole      (rs.getString("role"));
                u.setVehicleNo (rs.getString("vehicle_no"));
                u.setVehicleType(rs.getString("vehicle_type"));
                return u;
            }
        }
        return null;
    }

    // ═══════════════════════════════════════
    // GET USER BY ID
    // ═══════════════════════════════════════
    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId    (rs.getInt   ("user_id"));
                u.setName      (rs.getString("name"));
                u.setContact   (rs.getString("contact"));
                u.setUsername  (rs.getString("username"));
                u.setPassword  (rs.getString("password"));
                u.setRole      (rs.getString("role"));
                u.setVehicleNo (rs.getString("vehicle_no"));
                u.setVehicleType(rs.getString("vehicle_type"));
                return u;
            }
        }
        return null;
    }

    // ═══════════════════════════════════════
    // DELETE USER
    // ═══════════════════════════════════════
    public void deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }
}
