package Parkingsystem;

public class ParkingSlot {
    private int slotId;
    private String status; // Available, Occupied, Reserved
    private int floor;

    public ParkingSlot(int slotId, String status, int floor) {
        this.slotId = slotId;
        this.status = status;
        this.floor = floor;
    }

    public int getSlotId() { return slotId; }
    public String getStatus() { return status; }
    public int getFloor() { return floor; }

    public void setStatus(String status) {
        this.status = status;
    }
}

