package Parking;




    /**
     * ParkingSlot.java
     * Updated to include slotName (e.g. "A01", "B02")
     * which is needed by ParkingSlotDAO and view-slots.jsp
     */
    public class ParkingSlot {

        private int    slotId;
        private String slotName;   // e.g. "A01", "B02"
        private String status;     // "Available", "Occupied", "Reserved"
        private int    floor;

        public ParkingSlot(int slotId, String status, int floor) {
            this.slotId  = slotId;
            this.status  = status;
            this.floor   = floor;
        }

        // Getters
        public int    getSlotId()   { return slotId;   }
        public String getSlotName() { return slotName;  }
        public String getStatus()   { return status;   }
        public int    getFloor()    { return floor;    }

        // Setters
        public void setSlotName(String slotName) { this.slotName = slotName; }
        public void setStatus  (String status)   { this.status   = status;   }
        public void setFloor   (int floor)       { this.floor    = floor;    }
    }


