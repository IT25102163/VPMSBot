package Parking;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Handle logout
        if ("/logout".equals(req.getServletPath())) {
            handleLogout(req, res);
            return;
        }

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Empty check
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            res.sendRedirect("login.jsp?error=true");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = null;

        try {
            user = userDAO.getUserByUsername(username.trim());
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?error=true");
            return;
        }

        // Debug log — check what's in DB
        if (user != null) {
            System.out.println("[LOGIN] Found user: " + user.getUsername());
            System.out.println("[LOGIN] DB password: '" + user.getPassword() + "'");
            System.out.println("[LOGIN] Entered password: '" + password + "'");
            System.out.println("[LOGIN] Match: " + user.getPassword().equals(password));
        } else {
            System.out.println("[LOGIN] No user found for username: " + username);
        }

        // Password check
        if (user == null || !user.getPassword().equals(password)) {
            res.sendRedirect("login.jsp?error=true");
            return;
        }

        // Create session
        HttpSession session = req.getSession(true);
        session.setAttribute("userId",   user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("name",     user.getName());
        session.setAttribute("role",     user.getRole());
        session.setMaxInactiveInterval(3600);

        System.out.println("[LOGIN] SUCCESS — user=" + username + " role=" + user.getRole());

        // Redirect based on role
        if ("admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin");
        } else {
            res.sendRedirect(req.getContextPath() + "/home.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if ("/logout".equals(req.getServletPath())) {
            handleLogout(req, res);
            return;
        }
        req.getRequestDispatcher("login.jsp").forward(req, res);
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            System.out.println("[LOGOUT] userId=" + session.getAttribute("userId"));
            session.invalidate();
        }
        res.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
    }
}
