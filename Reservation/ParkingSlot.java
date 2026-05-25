package Parking;




    
    public class ParkingSlot {

        private int    slotId;
        private String slotName;   
        private String status;     
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
