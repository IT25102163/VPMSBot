package Parking;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

    @WebServlet({"/admin", "/deleteUser"})
    public class AdminServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse res)
                throws ServletException, IOException {

            // Load all users
            UserDAO userDAO = new UserDAO();
            List<User> allUsers = new ArrayList<>();
            try {
                allUsers = userDAO.getAllUsers();
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Load all slots
            ParkingSlotDAO slotDAO = new ParkingSlotDAO();
            List<ParkingSlot> allSlots = slotDAO.getAllSlots();
            int freeSlots = slotDAO.countFreeSlots();

            // Send to dashboard
            req.setAttribute("userList",  allUsers);
            req.setAttribute("slotList",  allSlots);
            req.setAttribute("freeSlots", freeSlots);
            req.setAttribute("totalUsers", allUsers.size());

            req.getRequestDispatcher("dashboard.jsp").forward(req, res);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse res)
                throws ServletException, IOException {

            String action = req.getServletPath();

            if ("/deleteUser".equals(action)) {
                try {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    new UserDAO().deleteUser(userId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            res.sendRedirect("admin");
        }
    }


