package parking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * ╔══════════════════════════════════════════════════════╗
 *  Park Smart – Security & Access Control
 *  Class  : SecurityServlet.java
 *  Package: parking
 *  Author : Member 4 – Security & Access Control
 * ╚══════════════════════════════════════════════════════╝
 *
 * Manages vehicle entry / exit and parking slot allocation.
 *
 * Data Structure : Stack<ParkingEntry>  (LIFO allocation)
 * Algorithm      : QuickSort on slot availability
 *
 * URL mappings:
 *   POST /security/entry  → record vehicle entry
 *   POST /security/exit   → record vehicle exit
 *   GET  /security/slots  → get all slot statuses (sorted)
 *   GET  /security/log    → get access log
 *   GET  /security/stack  → inspect current stack
 */
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

    // ── Total parking capacity ──
    private static final int TOTAL_SLOTS = 20;

    // ── Parking Slot array ──
    private static final ParkingSlot[] slots = new ParkingSlot[TOTAL_SLOTS];

    // ── Parking Stack (data structure – LIFO) ──
    private static final Deque<ParkingEntry> parkingStack = new ArrayDeque<>();

    // ── Access log ──
    private static final List<ParkingEntry> accessLog = new ArrayList<>();

    // ── Initialize slots ──
    static {
        for (int i = 0; i < TOTAL_SLOTS; i++) {
            slots[i] = new ParkingSlot(String.format("P%02d", i + 1));
        }
    }

    // ════════════════════════════════════════════════════
    //  GET – slots / log / stack
    // ════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAuthenticated(req, resp)) return;

        String path = req.getServletPath();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        switch (path) {
            case "/security/slots":  handleGetSlots(out);  break;
            case "/security/log":    handleGetLog(out);    break;
            case "/security/stack":  handleGetStack(out);  break;
            default:
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Unknown endpoint\"}");
        }
    }

    // ════════════════════════════════════════════════════
    //  POST – entry / exit
    // ════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAuthenticated(req, resp)) return;

        String path = req.getServletPath();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        switch (path) {
            case "/security/entry":  handleEntry(req, resp, out);  break;
            case "/security/exit":   handleExit(req, resp, out);   break;
            default:
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Unknown endpoint\"}");
        }
    }

    // ────────────────────────────────────────────────────
    //  ENTRY handler
    // ────────────────────────────────────────────────────
    private synchronized void handleEntry(HttpServletRequest req,
                                          HttpServletResponse resp,
                                          PrintWriter out) throws IOException {

        String vehicleNum = sanitize(req.getParameter("vehicleNumber"));
        String userName   = sanitize(req.getParameter("userName"));
        String userId     = sanitize(req.getParameter("userId"));
        String type       = sanitize(req.getParameter("vehicleType"));

        // Validate
        if (isBlank(vehicleNum) || isBlank(userName) || isBlank(userId)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"vehicleNumber, userName and userId are required.\"}");
            return;
        }

        // Duplicate check
        boolean alreadyIn = parkingStack.stream()
                .anyMatch(e -> e.vehicleNumber.equalsIgnoreCase(vehicleNum));
        if (alreadyIn) {
            resp.setStatus(HttpServletResponse.SC_CONFLICT);
            out.print("{\"success\":false,\"message\":\"Vehicle is already parked.\"}");
            return;
        }

        // Find first free slot
        ParkingSlot freeSlot = null;
        for (ParkingSlot s : slots) {
            if (s.isFree) { freeSlot = s; break; }
        }

        if (freeSlot == null) {
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            out.print("{\"success\":false,\"message\":\"No parking slots available.\"}");
            return;
        }

        // Allocate
        freeSlot.isFree       = false;
        freeSlot.vehicleNumber = vehicleNum.toUpperCase();

        ParkingEntry entry = new ParkingEntry();
        entry.vehicleNumber = vehicleNum.toUpperCase();
        entry.userName      = userName;
        entry.userId        = userId;
        entry.vehicleType   = (type == null ? "Car" : type);
        entry.slotId        = freeSlot.slotId;
        entry.entryTime     = LocalDateTime.now();
        entry.status        = "IN";
        entry.loggedBy      = loggedInUserId(req);

        // Push to stack
        parkingStack.push(entry);
        accessLog.add(0, entry);

        System.out.printf("[SecurityServlet] ENTRY  – vehicle=%s slot=%s user=%s%n",
                entry.vehicleNumber, entry.slotId, entry.userId);

        out.printf("{\"success\":true,\"slotId\":\"%s\",\"entryTime\":\"%s\"}",
                entry.slotId, entry.entryTime.format(FMT));
    }

    // ────────────────────────────────────────────────────
    //  EXIT handler
    // ────────────────────────────────────────────────────
    private synchronized void handleExit(HttpServletRequest req,
                                         HttpServletResponse resp,
                                         PrintWriter out) throws IOException {

        String vehicleNum = sanitize(req.getParameter("vehicleNumber"));

        if (isBlank(vehicleNum)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"vehicleNumber is required.\"}");
            return;
        }

        // Find in log
        ParkingEntry entry = accessLog.stream()
                .filter(e -> e.vehicleNumber.equalsIgnoreCase(vehicleNum) && "IN".equals(e.status))
                .findFirst().orElse(null);

        if (entry == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"success\":false,\"message\":\"Vehicle not found or already exited.\"}");
            return;
        }

        // Free the slot
        for (ParkingSlot s : slots) {
            if (s.slotId.equals(entry.slotId)) {
                s.isFree        = true;
                s.vehicleNumber = null;
                break;
            }
        }

        // Remove from stack (remove specific element)
        parkingStack.removeIf(e -> e.vehicleNumber.equalsIgnoreCase(vehicleNum));

        entry.exitTime = LocalDateTime.now();
        entry.status   = "OUT";

        // Run QuickSort to reorder slots
        quickSort(slots, 0, slots.length - 1);

        System.out.printf("[SecurityServlet] EXIT   – vehicle=%s slot=%s exitTime=%s%n",
                entry.vehicleNumber, entry.slotId, entry.exitTime.format(FMT));

        out.printf("{\"success\":true,\"slotId\":\"%s\",\"exitTime\":\"%s\"}",
                entry.slotId, entry.exitTime.format(FMT));
    }

    // ────────────────────────────────────────────────────
    //  GET slots (QuickSort applied before returning)
    // ────────────────────────────────────────────────────
    private void handleGetSlots(PrintWriter out) {
        ParkingSlot[] sorted = slots.clone();
        quickSort(sorted, 0, sorted.length - 1);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < sorted.length; i++) {
            ParkingSlot s = sorted[i];
            if (i > 0) sb.append(",");
            sb.append(String.format(
                "{\"slotId\":\"%s\",\"free\":%b,\"vehicle\":\"%s\"}",
                s.slotId, s.isFree, s.vehicleNumber == null ? "" : s.vehicleNumber));
        }
        sb.append("]");
        out.print(sb);
    }

    // ────────────────────────────────────────────────────
    //  GET access log
    // ────────────────────────────────────────────────────
    private void handleGetLog(PrintWriter out) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < accessLog.size(); i++) {
            ParkingEntry e = accessLog.get(i);
            if (i > 0) sb.append(",");
            sb.append(String.format(
                "{\"vehicle\":\"%s\",\"userName\":\"%s\",\"userId\":\"%s\"," +
                "\"type\":\"%s\",\"slot\":\"%s\",\"entry\":\"%s\"," +
                "\"exit\":\"%s\",\"status\":\"%s\"}",
                e.vehicleNumber, e.userName, e.userId, e.vehicleType,
                e.slotId,
                e.entryTime.format(FMT),
                e.exitTime != null ? e.exitTime.format(FMT) : "",
                e.status));
        }
        sb.append("]");
        out.print(sb);
    }

    // ────────────────────────────────────────────────────
    //  GET stack contents
    // ────────────────────────────────────────────────────
    private void handleGetStack(PrintWriter out) {
        StringBuilder sb = new StringBuilder("[");
        Iterator<ParkingEntry> it = parkingStack.iterator();
        boolean first = true;
        while (it.hasNext()) {
            ParkingEntry e = it.next();
            if (!first) sb.append(",");
            first = false;
            sb.append(String.format(
                "{\"vehicle\":\"%s\",\"slot\":\"%s\",\"entry\":\"%s\"}",
                e.vehicleNumber, e.slotId, e.entryTime.format(FMT)));
        }
        sb.append("]");
        out.print(sb);
    }

    // ════════════════════════════════════════════════════
    //  QUICK SORT – sort slots (free first, then occupied)
    // ════════════════════════════════════════════════════
    private void quickSort(ParkingSlot[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quickSort(arr, low, pi - 1);
            quickSort(arr, pi + 1, high);
        }
    }

    private int partition(ParkingSlot[] arr, int low, int high) {
        // Free slots (true=0) should come before occupied (false=1)
        int pivot = arr[high].isFree ? 0 : 1;
        int i = low - 1;

        for (int j = low; j < high; j++) {
            int val = arr[j].isFree ? 0 : 1;
            if (val <= pivot) {
                i++;
                ParkingSlot tmp = arr[i];
                arr[i] = arr[j];
                arr[j] = tmp;
            }
        }
        ParkingSlot tmp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high]  = tmp;
        return i + 1;
    }

    // ════════════════════════════════════════════════════
    //  AUTH CHECK
    // ════════════════════════════════════════════════════
    private boolean isAuthenticated(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("application/json");
            resp.getWriter().print("{\"error\":\"Unauthorized. Please login.\"}");
            return false;
        }
        return true;
    }

    private String loggedInUserId(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null ? (String) s.getAttribute("userId") : "UNKNOWN";
    }

    // ════════════════════════════════════════════════════
    //  UTILITY
    // ════════════════════════════════════════════════════
    private String sanitize(String input) {
        if (input == null) return null;
        return input.replaceAll("<[^>]*>", "").trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.isEmpty();
    }

    // ════════════════════════════════════════════════════
    //  INNER CLASSES
    // ════════════════════════════════════════════════════

    /** Represents one physical parking slot */
    static class ParkingSlot {
        String  slotId;
        boolean isFree = true;
        String  vehicleNumber = null;

        ParkingSlot(String slotId) { this.slotId = slotId; }
    }

    /** Represents one access record (entry or entry+exit) */
    static class ParkingEntry {
        String        vehicleNumber;
        String        userName;
        String        userId;
        String        vehicleType;
        String        slotId;
        LocalDateTime entryTime;
        LocalDateTime exitTime;
        String        status;   // "IN" | "OUT"
        String        loggedBy;
    }
}
