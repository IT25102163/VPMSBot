package Parking;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reservations")
public class ReservationServlet extends HttpServlet {

    public static List<Reservation> reservations = new ArrayList<>();
    public static int nextId = 1;

    private ParkingSlotDAO slotDAO = new ParkingSlotDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("reservations.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // ADD RESERVATION
        if ("add".equals(action)) {
            try {
                int    slotId  = Integer.parseInt(req.getParameter("slotId"));
                String vehicle = req.getParameter("vehicle");
                String user    = req.getParameter("user");

                int autoId = nextId++;
                reservations.add(new Reservation(autoId, slotId, vehicle, user));

                // Slot turns YELLOW
                slotDAO.updateSlotStatus(slotId, "Reserved");

                res.sendRedirect("reservations?success=true");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect("reservations?error=true");
                return;
            }
        }

        // CANCEL RESERVATION
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Reservation toDelete = null;
                for (Reservation r : reservations) {
                    if (r.getReservationId() == id) { toDelete = r; break; }
                }
                if (toDelete != null) {
                    // Slot turns GREEN
                    slotDAO.updateSlotStatus(toDelete.getSlotId(), "Available");
                    reservations.remove(toDelete);
                }
            } catch (Exception e) { e.printStackTrace(); }
        }

        // VEHICLE EXIT — called from SecurityServlet when a reserved vehicle exits
        // Finds any reservation for that vehicle and frees the slot
        if ("exit".equals(action)) {
            try {
                String vehicleNo = req.getParameter("vehicle");
                Reservation toExit = null;
                for (Reservation r : reservations) {
                    if (r.getVehicleNo().equalsIgnoreCase(vehicleNo)) {
                        toExit = r;
                        break;
                    }
                }
                if (toExit != null) {
                    slotDAO.updateSlotStatus(toExit.getSlotId(), "Available");
                    reservations.remove(toExit);
                }
            } catch (Exception e) { e.printStackTrace(); }
        }

        res.sendRedirect("reservations");
    }
}
