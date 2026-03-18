package Parkingsystem;

public class Reservation {
    private int reservationId;
    private int slotId;
    private String vehicleNo;
    private String userName;

    public Reservation(int reservationId, int slotId, String vehicleNo, String userName) {
        this.reservationId = reservationId;
        this.slotId = slotId;
        this.vehicleNo = vehicleNo;
        this.userName = userName;
    }

    public int getReservationId() { return reservationId; }
    public int getSlotId() { return slotId; }
    public String getVehicleNo() { return vehicleNo; }
    public String getUserName() { return userName; }
}

