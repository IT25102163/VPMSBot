package Parking;

import java.sql.*;
import java.util.*;

public class StaffDAO {

    public void addStaff(Staff staff) throws SQLException {
        String sql = "INSERT INTO staff(name,email,phone,position,permissions) VALUES(?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, staff.getName());
            stmt.setString(2, staff.getEmail());
            stmt.setString(3, staff.getPhone());
            stmt.setString(4, staff.getPosition());
            stmt.setString(5, staff.getPermissions());
            stmt.executeUpdate();
        }
    }

    public List<Staff> getAllStaff() throws SQLException {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM staff";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Staff(
                        rs.getInt("staff_id"), rs.getString("name"),
                        rs.getString("email"), rs.getString("phone"),
                        rs.getString("position"), rs.getString("permissions")));
            }
        }
        return list;
    }

    // GET BY ID — for edit form
    public Staff getStaffById(int staffId) throws SQLException {
        String sql = "SELECT * FROM staff WHERE staff_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Staff(
                        rs.getInt("staff_id"), rs.getString("name"),
                        rs.getString("email"), rs.getString("phone"),
                        rs.getString("position"), rs.getString("permissions"));
            }
        }
        return null;
    }

    // UPDATE — for edit staff form
    public void updateStaff(Staff staff) throws SQLException {
        String sql = "UPDATE staff SET name=?,email=?,phone=?,position=?,permissions=? WHERE staff_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, staff.getName());
            stmt.setString(2, staff.getEmail());
            stmt.setString(3, staff.getPhone());
            stmt.setString(4, staff.getPosition());
            stmt.setString(5, staff.getPermissions());
            stmt.setInt   (6, staff.getStaffId());
            stmt.executeUpdate();
        }
    }

    public void deleteStaff(int staffId) throws SQLException {
        String sql = "DELETE FROM staff WHERE staff_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.executeUpdate();
        }
    }
}
