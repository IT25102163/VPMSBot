package Parking;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/staff", "/editStaff"})
public class StaffServlet extends HttpServlet {

    private StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String role = (String) req.getSession(false).getAttribute("role");
        if (!"admin".equals(role)) { res.sendRedirect("home.jsp"); return; }

        String path = req.getServletPath();

        // EDIT — load staff member into form
        if ("/editStaff".equals(path)) {
            try {
                int id = Integer.parseInt(req.getParameter("staffId"));
                Staff s = staffDAO.getStaffById(id);
                req.setAttribute("editStaff", s);
            } catch (Exception e) { e.printStackTrace(); }
        }

        List<Staff> staffList = new ArrayList<>();
        try { staffList = staffDAO.getAllStaff(); } catch (Exception e) { e.printStackTrace(); }
        req.setAttribute("staffList", staffList);
        req.getRequestDispatcher("staff.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String role = (String) req.getSession(false).getAttribute("role");
        if (!"admin".equals(role)) { res.sendRedirect("home.jsp"); return; }

        String path   = req.getServletPath();
        String action = req.getParameter("action");

        // EDIT STAFF
        if ("/editStaff".equals(path)) {
            try {
                Staff s = new Staff(
                        Integer.parseInt(req.getParameter("staffId")),
                        req.getParameter("name"),
                        req.getParameter("email"),
                        req.getParameter("phone"),
                        req.getParameter("position"),
                        req.getParameter("permissions"));
                staffDAO.updateStaff(s);
                res.sendRedirect("staff?success=updated");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect("staff?error=true");
            }
            return;
        }

        // ADD
        if ("add".equals(action)) {
            Staff s = new Staff(req.getParameter("name"), req.getParameter("email"),
                    req.getParameter("phone"), req.getParameter("position"), req.getParameter("permissions"));
            try { staffDAO.addStaff(s); res.sendRedirect("staff?success=true"); }
            catch (Exception e) { e.printStackTrace(); res.sendRedirect("staff?error=true"); }
            return;
        }

        // DELETE
        if ("delete".equals(action)) {
            try { staffDAO.deleteStaff(Integer.parseInt(req.getParameter("staffId"))); }
            catch (Exception e) { e.printStackTrace(); }
        }

        res.sendRedirect("staff");
    }
}
