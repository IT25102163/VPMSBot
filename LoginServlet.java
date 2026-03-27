package parking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * ╔══════════════════════════════════════════════════════╗
 *  Park Smart – Security & Access Control
 *  Class  : LoginServlet.java
 *  Package: parking
 *  Author : Member 4 – Security & Access Control
 * ╚══════════════════════════════════════════════════════╝
 *
 * Handles user authentication (login / logout) for the
 * Security & Access Control module of Park Smart.
 *
 * URL mappings:
 *   POST /login  → authenticate user, create session
 *   GET  /login  → return current session status (JSON)
 *   POST /logout → invalidate session
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    // ── In-memory user store (replace with DB in production) ──
    private static final Map<String, String[]> USERS = new HashMap<>();

    static {
        // Format: userId → { hashedPassword, displayName, role }
        USERS.put("SEC001", new String[]{"1234", "Guard A",  "SECURITY"});
        USERS.put("SEC002", new String[]{"abcd", "Guard B",  "SECURITY"});
        USERS.put("ADM001", new String[]{"admin","Admin",    "ADMIN"});
    }

    // ────────────────────────────────────────────────────
    //  POST /login  – Authenticate & create session
    // ────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            handleLogout(req, resp);
            return;
        }

        // Read form parameters
        String userId   = sanitize(req.getParameter("userId"));
        String username = sanitize(req.getParameter("username"));
        String password = req.getParameter("password");   // raw; hash before comparing in production

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        // ── Basic validation ──
        if (userId == null || userId.isEmpty() ||
            username == null || username.isEmpty() ||
            password == null || password.isEmpty()) {

            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"All fields are required.\"}");
            return;
        }

        // ── Credential check ──
        String[] record = USERS.get(userId.toUpperCase());

        boolean valid = record != null
                && record[0].equals(password)                              // password match
                && record[1].equalsIgnoreCase(username.trim());            // name match

        if (!valid) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Invalid credentials.\"}");
            // Security log
            System.out.printf("[LoginServlet] FAILED login attempt – userId=%s username=%s ip=%s%n",
                    userId, username, req.getRemoteAddr());
            return;
        }

        // ── Create session ──
        HttpSession session = req.getSession(true);
        session.setAttribute("userId",   userId.toUpperCase());
        session.setAttribute("username", record[1]);
        session.setAttribute("role",     record[2]);
        session.setMaxInactiveInterval(60 * 60);   // 1 hour

        System.out.printf("[LoginServlet] LOGIN  – userId=%s name=%s role=%s ip=%s%n",
                userId, record[1], record[2], req.getRemoteAddr());

        out.printf("{\"success\":true,\"userId\":\"%s\",\"username\":\"%s\",\"role\":\"%s\"}",
                userId.toUpperCase(), record[1], record[2]);
    }

    // ────────────────────────────────────────────────────
    //  GET /login  – Return session status
    // ────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            out.printf("{\"loggedIn\":true,\"userId\":\"%s\",\"username\":\"%s\",\"role\":\"%s\"}",
                    session.getAttribute("userId"),
                    session.getAttribute("username"),
                    session.getAttribute("role"));
        } else {
            out.print("{\"loggedIn\":false}");
        }
    }

    // ────────────────────────────────────────────────────
    //  Logout helper
    // ────────────────────────────────────────────────────
    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            System.out.printf("[LoginServlet] LOGOUT – userId=%s%n", session.getAttribute("userId"));
            session.invalidate();
        }

        resp.setContentType("application/json");
        resp.getWriter().print("{\"success\":true,\"message\":\"Logged out successfully.\"}");
    }

    // ────────────────────────────────────────────────────
    //  Utility
    // ────────────────────────────────────────────────────
    private String sanitize(String input) {
        if (input == null) return null;
        // Remove HTML tags to prevent XSS
        return input.replaceAll("<[^>]*>", "").trim();
    }
}
