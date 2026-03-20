package servlet.model;

public class ReservationServletextendsHttpServlet {

import model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

        static ArrayList<Reservation> reservations = new ArrayList<>();

        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            PrintWriter out = response.getWriter();
            out.println("<h2>Reservations</h2>");

            for (Reservation r : reservations) {
                out.println("ID: " + r.getReservationId() +
                        " | Slot: " + r.getSlotId() +
                        " | Vehicle: " + r.getVehicleNo() +
                        " | User: " + r.getUserName() + "<br>");
            }
        }

        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String action = request.getParameter("action");

            if (action.equals("add")) {
                int id = Integer.parseInt(request.getParameter("id"));
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                String vehicle = request.getParameter("vehicle");
                String user = request.getParameter("user");

                reservations.add(new Reservation(id, slotId, vehicle, user));
            }

            if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                reservations.removeIf(r -> r.getReservationId() == id);
            }

            response.sendRedirect("reservations");
        }
    }

