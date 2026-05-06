package Parking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "SecurityServlet", urlPatterns = {
    "/security/entry",
    "/security/exit",
    "/security/slots",
    "/security/log",
    "/security/stack"
})
public class SecurityServlet extends HttpServlet {

    private static final DateTimeFormatter FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private static final int TOTAL_SLOTS = 20;
    private static final SecurityParkingSlot[] slots = new SecurityParkingSlot[TOTAL_SLOTS];
    private static final Deque<ParkingEntry> parkingStack = new ArrayDeque<>();
    private static final List<ParkingEntry>  accessLog    = new ArrayList<>();

    static {
        for (int i = 0; i < TOTAL_SLOTS; i++)
            slots[i] = new SecurityParkingSlot(String.format("P%02d", i + 1));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!isAuthenticated(req, res)) return;
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        PrintWriter out = res.getWriter();
        switch (req.getServletPath()) {
            case "/security/slots": handleGetSlots(out); break;
            case "/security/log":   handleGetLog(out);   break;
            case "/security/stack": handleGetStack(out); break;
            default: res.setStatus(404); out.print("{\"error\":\"Not found\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!isAuthenticated(req, res)) return;
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        PrintWriter out = res.getWriter();
        switch (req.getServletPath()) {
            case "/security/entry": handleEntry(req, res, out); break;
            case "/security/exit":  handleExit (req, res, out); break;
            default: res.setStatus(404); out.print("{\"error\":\"Not found\"}");
        }
    }

    private synchronized void handleEntry(HttpServletRequest req,
                                          HttpServletResponse res,
                                          PrintWriter out) throws IOException {
        String vehicleNum = sanitize(req.getParameter("vehicleNumber"));
        String userId     = sanitize(req.getParameter("userId"));
        String slotIdStr  = sanitize(req.getParameter("slotId"));
        String type       = sanitize(req.getParameter("vehicleType"));

        if (isBlank(vehicleNum) || isBlank(userId)) {
            res.setStatus(400);
            out.print("{\"success\":false,\"message\":\"Vehicle number and user ID are required.\"}");
            return;
        }

        // Check already parked
        for (ParkingEntry e : parkingStack) {
            if (e.vehicleNumber.equalsIgnoreCase(vehicleNum)) {
                res.setStatus(409);
                out.print("{\"success\":false,\"message\":\"Vehicle is already parked.\"}");
                return;
            }
        }

        // Use provided slotId or find free slot
        String assignedSlotId = null;
        int dbSlotId = 0;

        if (!isBlank(slotIdStr)) {
            // Use the slot the user specified
            dbSlotId = Integer.parseInt(slotIdStr);
            assignedSlotId = "P" + String.format("%02d", dbSlotId);
        } else {
            // Find first free internal slot
            SecurityParkingSlot freeSlot = null;
            for (SecurityParkingSlot s : slots) {
                if (s.isFree) { freeSlot = s; break; }
            }
            if (freeSlot == null) {
                res.setStatus(503);
                out.print("{\"success\":false,\"message\":\"No parking slots available.\"}");
                return;
            }
            assignedSlotId = freeSlot.slotId;
            dbSlotId = Integer.parseInt(freeSlot.slotId.replace("P", ""));
        }

        // Mark internal slot as occupied
        for (SecurityParkingSlot s : slots) {
            if (s.slotId.equals(assignedSlotId)) {
                s.isFree        = false;
                s.vehicleNumber = vehicleNum.toUpperCase();
                break;
            }
        }

        ParkingEntry entry = new ParkingEntry();
        entry.vehicleNumber = vehicleNum.toUpperCase();
        entry.userId        = userId;
        entry.vehicleType   = type != null ? type : "Car";
        entry.slotId        = assignedSlotId;
        entry.dbSlotId      = dbSlotId;
        entry.entryTime     = LocalDateTime.now();
        entry.status        = "IN";

        parkingStack.push(entry);
        accessLog.add(0, entry);

        // ── UPDATE SLOT TO OCCUPIED IN DATABASE (turns RED) ──
        try {
            new ParkingSlotDAO().updateSlotStatus(dbSlotId, "Occupied");
            System.out.println("[Security] Slot " + dbSlotId + " set to Occupied");
        } catch (Exception e) {
            System.out.println("[Security] DB slot update failed: " + e.getMessage());
        }

        // Save to parking history
        try {
            int uid = Integer.parseInt(userId);
            new ParkingLotDAO().recordEntry(vehicleNum.toUpperCase(), uid, dbSlotId);
        } catch (Exception e) {
            System.out.println("[Security] History save failed: " + e.getMessage());
        }

        System.out.println("[Security] ENTRY vehicle=" + vehicleNum + " slot=" + assignedSlotId);
        out.printf("{\"success\":true,\"slotId\":\"%s\",\"entryTime\":\"%s\"}",
                assignedSlotId, entry.entryTime.format(FMT));
    }

    private synchronized void handleExit(HttpServletRequest req,
                                         HttpServletResponse res,
                                         PrintWriter out) throws IOException {
        String vehicleNum = sanitize(req.getParameter("vehicleNumber"));

        if (isBlank(vehicleNum)) {
            res.setStatus(400);
            out.print("{\"success\":false,\"message\":\"Vehicle number is required.\"}");
            return;
        }

        // Find in log
        ParkingEntry entry = null;
        for (ParkingEntry e : accessLog) {
            if (e.vehicleNumber.equalsIgnoreCase(vehicleNum) && "IN".equals(e.status)) {
                entry = e;
                break;
            }
        }

        if (entry == null) {
            res.setStatus(404);
            out.print("{\"success\":false,\"message\":\"Vehicle not found or already exited.\"}");
            return;
        }

        // Free internal slot
        for (SecurityParkingSlot s : slots) {
            if (s.slotId.equals(entry.slotId)) {
                s.isFree        = true;
                s.vehicleNumber = null;
                break;
            }
        }

        parkingStack.removeIf(e -> e.vehicleNumber.equalsIgnoreCase(vehicleNum));
        entry.exitTime = LocalDateTime.now();
        entry.status   = "OUT";

        quickSort(slots, 0, slots.length - 1);

        // ── UPDATE SLOT TO AVAILABLE IN DATABASE (turns GREEN) ──
        try {
            new ParkingSlotDAO().updateSlotStatus(entry.dbSlotId, "Available");
            System.out.println("[Security] Slot " + entry.dbSlotId + " set to Available");
        } catch (Exception e) {
            System.out.println("[Security] DB slot update failed: " + e.getMessage());
        }

        // Free reserved slot if any
        try {
            for (Reservation r : ReservationServlet.reservations) {
                if (r.getVehicleNo().equalsIgnoreCase(vehicleNum)) {
                    new ParkingSlotDAO().updateSlotStatus(r.getSlotId(), "Available");
                    ReservationServlet.reservations.remove(r);
                    break;
                }
            }
        } catch (Exception e) {
            System.out.println("[Security] Reservation cleanup failed: " + e.getMessage());
        }

        System.out.println("[Security] EXIT vehicle=" + vehicleNum + " slot=" + entry.slotId);
        out.printf("{\"success\":true,\"slotId\":\"%s\",\"exitTime\":\"%s\"}",
                entry.slotId, entry.exitTime.format(FMT));
    }

    private void handleGetSlots(PrintWriter out) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < slots.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(String.format("{\"slotId\":\"%s\",\"free\":%b,\"vehicle\":\"%s\"}",
                slots[i].slotId, slots[i].isFree,
                slots[i].vehicleNumber == null ? "" : slots[i].vehicleNumber));
        }
        sb.append("]");
        out.print(sb);
    }

    private void handleGetLog(PrintWriter out) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < accessLog.size(); i++) {
            ParkingEntry e = accessLog.get(i);
            if (i > 0) sb.append(",");
            sb.append(String.format(
                "{\"vehicle\":\"%s\",\"type\":\"%s\",\"slot\":\"%s\"," +
                "\"entry\":\"%s\",\"exit\":\"%s\",\"status\":\"%s\"}",
                e.vehicleNumber, e.vehicleType, e.slotId,
                e.entryTime.format(FMT),
                e.exitTime != null ? e.exitTime.format(FMT) : "",
                e.status));
        }
        sb.append("]");
        out.print(sb);
    }

    private void handleGetStack(PrintWriter out) {
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (ParkingEntry e : parkingStack) {
            if (!first) sb.append(",");
            first = false;
            sb.append(String.format("{\"vehicle\":\"%s\",\"slot\":\"%s\",\"entry\":\"%s\"}",
                e.vehicleNumber, e.slotId, e.entryTime.format(FMT)));
        }
        sb.append("]");
        out.print(sb);
    }

    private void quickSort(SecurityParkingSlot[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quickSort(arr, low, pi - 1);
            quickSort(arr, pi + 1, high);
        }
    }

    private int partition(SecurityParkingSlot[] arr, int low, int high) {
        int pivot = arr[high].isFree ? 0 : 1;
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if ((arr[j].isFree ? 0 : 1) <= pivot) {
                i++;
                SecurityParkingSlot tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
            }
        }
        SecurityParkingSlot tmp = arr[i+1]; arr[i+1] = arr[high]; arr[high] = tmp;
        return i + 1;
    }

    private boolean isAuthenticated(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            res.setStatus(401);
            res.setContentType("application/json");
            res.getWriter().print("{\"error\":\"Unauthorized\"}");
            return false;
        }
        return true;
    }

    private String sanitize(String input) {
        return input == null ? null : input.replaceAll("<[^>]*>", "").trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.isEmpty();
    }

    static class SecurityParkingSlot {
        String  slotId;
        boolean isFree        = true;
        String  vehicleNumber = null;
        SecurityParkingSlot(String id) { this.slotId = id; }
    }

    static class ParkingEntry {
        String        vehicleNumber;
        String        userId;
        String        vehicleType;
        String        slotId;
        int           dbSlotId;
        LocalDateTime entryTime;
        LocalDateTime exitTime;
        String        status;
    }
}
