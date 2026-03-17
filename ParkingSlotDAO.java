package com.parksmart.admin.dao;

import com.parksmart.admin.model.ParkingSlot;
import com.parksmart.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParkingSlotDAO {

    // Add a new parking slot
    public void addParkingSlot(ParkingSlot slot) throws SQLException {
        String sql = "INSERT INTO parking_slots(slot_number, level, type, status) VALUES(?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slot.getSlotNumber());
            stmt.setString(2, slot.getLevel());
            stmt.setString(3, slot.getType());
            stmt.setString(4, slot.getStatus());
            stmt.executeUpdate();
        }
    }

    // View all parking slots
    public List<ParkingSlot> getAllSlots() throws SQLException {
        List<ParkingSlot> slots = new ArrayList<>();
        String sql = "SELECT * FROM parking_slots";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ParkingSlot slot = new ParkingSlot(
                        rs.getInt("slot_id"),
                        rs.getString("slot_number"),
                        rs.getString("level"),
                        rs.getString("type"),
                        rs.getString("status")
                );
                slots.add(slot);
            }
        }
        return slots;
    }

    // Update a parking slot
    public void updateParkingSlot(ParkingSlot slot) throws SQLException {
        String sql = "UPDATE parking_slots SET slot_number=?, level=?, type=?, status=? WHERE slot_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slot.getSlotNumber());
            stmt.setString(2, slot.getLevel());
            stmt.setString(3, slot.getType());
            stmt.setString(4, slot.getStatus());
            stmt.setInt(5, slot.getSlotId());
            stmt.executeUpdate();
        }
    }

    // Delete a parking slot
    public void deleteParkingSlot(int slotId) throws SQLException {
        String sql = "DELETE FROM parking_slots WHERE slot_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            stmt.executeUpdate();
        }
    }

    // Find a slot by ID
    public ParkingSlot getSlotById(int slotId) throws SQLException {
        String sql = "SELECT * FROM parking_slots WHERE slot_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new ParkingSlot(
                            rs.getInt("slot_id"),
                            rs.getString("slot_number"),
                            rs.getString("level"),
                            rs.getString("type"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }
}