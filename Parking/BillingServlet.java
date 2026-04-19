package Parking;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        ParkingLotDAO dao = new ParkingLotDAO();
        req.setAttribute("billings", dao.getBillings());
        req.getRequestDispatcher("billing.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        ParkingLotDAO dao = new ParkingLotDAO();

        // DELETE
        if ("delete".equals(action)) {
            try { dao.deleteBilling(Integer.parseInt(req.getParameter("billingId"))); }
            catch (Exception e) { e.printStackTrace(); }
            res.sendRedirect("billing");
            return;
        }

        // UPDATE STATUS — adjust bill
        if ("updateStatus".equals(action)) {
            try {
                int    id     = Integer.parseInt(req.getParameter("billingId"));
                String status = req.getParameter("status");
                dao.updateBillingStatus(id, status);
            } catch (Exception e) { e.printStackTrace(); }
            res.sendRedirect("billing?success=updated");
            return;
        }

        // PROCESS NEW PAYMENT
        String vehicleNo     = req.getParameter("vehicleNo");
        String hoursStr      = req.getParameter("hours");
        String paymentMethod = req.getParameter("paymentMethod");
        String customerName  = req.getParameter("customerName");
        try {
            int    hours  = Integer.parseInt(hoursStr);
            double amount = dao.calculateBill(hours);
            dao.saveBilling(new Billing(vehicleNo, amount, paymentMethod, "paid"));
            dao.recordExit(vehicleNo, amount);
            // Pass details in URL so receipt can show them after redirect
            res.sendRedirect("billing?success=true"
                    + "&v=" + java.net.URLEncoder.encode(vehicleNo != null ? vehicleNo : "", "UTF-8")
                    + "&h=" + hours
                    + "&m=" + java.net.URLEncoder.encode(paymentMethod != null ? paymentMethod : "Cash", "UTF-8")
                    + "&n=" + java.net.URLEncoder.encode(customerName != null ? customerName : "", "UTF-8")
                    + "&a=" + (int) amount);
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("billing?error=true");
        }
    }
}
