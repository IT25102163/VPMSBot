package Parking;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/register", "/editUser"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        // Edit user — load user data into form
        if ("/editUser".equals(path)) {
            try {
                int userId = Integer.parseInt(req.getParameter("userId"));
                User u = new UserDAO().getUserById(userId);
                req.setAttribute("editUser", u);
            } catch (Exception e) { e.printStackTrace(); }
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        req.getRequestDispatcher("register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        // EDIT USER
        if ("/editUser".equals(path)) {
            try {
                int    userId     = Integer.parseInt(req.getParameter("userId"));
                String name       = req.getParameter("name");
                String contact    = req.getParameter("contact");
                String vehicleNo  = req.getParameter("vehicleNo");
                String vehicleType = req.getParameter("vehicleType");

                User u = new User();
                u.setUserId    (userId);
                u.setName      (name);
                u.setContact   (contact);
                u.setVehicleNo (vehicleNo != null ? vehicleNo.toUpperCase().trim() : "");
                u.setVehicleType(vehicleType);

                new UserDAO().updateUser(u);
                res.sendRedirect("register?success=updated");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect("register?error=true");
            }
            return;
        }

        //  REGISTER NEW USER 
                
        String name        = req.getParameter("name");
        String contact     = req.getParameter("contact");
        String username    = req.getParameter("username");
        String password    = req.getParameter("password");
        String vehicleNo   = req.getParameter("vehicleNo");
        String vehicleType = req.getParameter("vehicleType");
        String from        = req.getParameter("from");

        User user = new User();
        user.setName       (name);
        user.setContact    (contact);
        user.setUsername   (username != null ? username.trim() : "");
        user.setPassword   (password);
        user.setVehicleNo  (vehicleNo != null ? vehicleNo.trim().toUpperCase() : "");
        user.setVehicleType(vehicleType);
        user.setRole       ("user");

        UserDAO userDAO = new UserDAO();
        try {
            userDAO.addUser(user);

            // Auto login after registration
            User saved = userDAO.getUserByUsername(user.getUsername());
            if (saved != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("userId",   saved.getUserId());
                session.setAttribute("username", saved.getUsername());
                session.setAttribute("name",     saved.getName());
                session.setAttribute("role",     saved.getRole());
                session.setMaxInactiveInterval(3600);
            }

            if ("dashboard".equals(from)) {
                res.sendRedirect("register?success=true");
            } else {
                res.sendRedirect("home.jsp");
            }
        } catch (Exception e) {
            String msg  = e.getMessage();
            String base = "dashboard".equals(from) ? "register?from=dashboard" : "login.jsp?mode=register";
            if ("USERNAME_EXISTS".equals(msg))   res.sendRedirect(base + "&error=username");
            else if ("VEHICLE_EXISTS".equals(msg)) res.sendRedirect(base + "&error=vehicle");
            else { e.printStackTrace(); res.sendRedirect(base + "&error=true"); }
        }
    }
}
