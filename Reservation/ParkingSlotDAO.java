package Parking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import java.sql.*;
import java.util.*;

    
    public class ParkingSlotDAO {

      
        public List<ParkingSlot> getAllSlots() {
            List<ParkingSlot> list = new ArrayList<>();
            String sql = "SELECT * FROM parking_slots ORDER BY slot_name";
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    ParkingSlot slot = new ParkingSlot(
                            rs.getInt("slot_id"),
                            rs.getString("status"),
                            rs.getInt("floor")
                    );
                    slot.setSlotName(rs.getString("slot_name"));
                    list.add(slot);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return list;
        }

        
        public List<ParkingSlot> getAvailableSlots() {
            List<ParkingSlot> list = new ArrayList<>();
            String sql = "SELECT * FROM parking_slots WHERE status = 'Available' ORDER BY slot_name";
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    ParkingSlot slot = new ParkingSlot(
                            rs.getInt("slot_id"),
                            rs.getString("status"),
                            rs.getInt("floor")
                    );
                    slot.setSlotName(rs.getString("slot_name"));
                    list.add(slot);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return list;
        }

        
        public boolean updateSlotStatus(int slotId, String status) {
            String sql = "UPDATE parking_slots SET status = ? WHERE slot_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, slotId);
                ps.executeUpdate();
                return true;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        
        public ParkingSlot getSlotById(int slotId) {
            String sql = "SELECT * FROM parking_slots WHERE slot_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, slotId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    ParkingSlot slot = new ParkingSlot(
                            rs.getInt("slot_id"),
                            rs.getString("status"),
                            rs.getInt("floor")
                    );
                    slot.setSlotName(rs.getString("slot_name"));
                    return slot;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return null;
        }

        
        public int countFreeSlots() {
            String sql = "SELECT COUNT(*) FROM parking_slots WHERE status = 'Available'";
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                if (rs.next()) return rs.getInt(1);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return 0;
        }
    }

