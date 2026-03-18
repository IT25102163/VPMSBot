package servlet.model;
import model.ParkingSlot;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class SlotServlet extends HttpServlet {

    static ArrayList<ParkingSlot> slots = new ArrayList<>();

    @Override
    public void init() {
        // sample data
        slots.add(new ParkingSlot(1, "Available", 1));
        slots.add(new ParkingSlot(2, "Occupied", 1));
        slots.add(new ParkingSlot(3, "Reserved", 2));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h2>Parking Slot Grid View</h2>");

        for (ParkingSlot s : slots) {
            out.println("Slot: " + s.getSlotId() +
                    " | Floor: " + s.getFloor() +
                    " | Status: " + s.getStatus() + "<br>");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action.equals("add")) {
            int id = Integer.parseInt(request.getParameter("id"));
            int floor = Integer.parseInt(request.getParameter("floor"));

            slots.add(new ParkingSlot(id, "Available", floor));
        }

        if (action.equals("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            for (ParkingSlot s : slots) {
                if (s.getSlotId() == id) {
                    s.setStatus(status);
                }
            }
        }

        if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            slots.removeIf(s -> s.getSlotId() == id);
        }

        response.sendRedirect("slots");
    }
}
