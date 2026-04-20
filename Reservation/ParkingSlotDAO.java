package Parking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import java.sql.*;
import java.util.*;

    /**
     * ParkingSlotDAO
     * YOUR LEADER SAID: This shows customers the slot GRID
     * - Get all slots (for the visual grid)
     * - Update slot status (available/occupied/reserved)
     * - Get available slots only
     */
    public class ParkingSlotDAO {

        // ═══════════════════════════════════════
        // GET ALL SLOTS — for the visual grid
        // Used by view-slots.jsp to show all slots
        // ═══════════════════════════════════════
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

        // ═══════════════════════════════════════
        // GET AVAILABLE SLOTS ONLY
        // Used when a vehicle needs to be assigned a slot
        // ═══════════════════════════════════════
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

        // ═══════════════════════════════════════
        // UPDATE SLOT STATUS
        // Called when vehicle enters (set Occupied)
        // or exits (set Available)
        // ═══════════════════════════════════════
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

        // ═══════════════════════════════════════
        // GET SLOT BY ID
        // ═══════════════════════════════════════
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

        // ═══════════════════════════════════════
        // COUNT FREE SLOTS
        // Used on dashboard to show number available
        // ═══════════════════════════════════════
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


