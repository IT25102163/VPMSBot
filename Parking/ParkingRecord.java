package Parking;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

    public class ParkingRecord {
        private int           id;
        private String        vehiclePlate;
        private String        slotNumber;
        private LocalDateTime entryTime;
        private LocalDateTime exitTime;
        private long          durationMins;
        private String        status;
        private String        notes;

        public int           getId()           { return id;           }
        public String        getVehiclePlate() { return vehiclePlate; }
        public String        getSlotNumber()   { return slotNumber;   }
        public LocalDateTime getEntryTime()    { return entryTime;    }
        public LocalDateTime getExitTime()     { return exitTime;     }
        public long          getDurationMins() { return durationMins; }
        public String        getStatus()       { return status;       }
        public String        getNotes()        { return notes;        }

        public void setId          (int id)                  { this.id           = id;           }
        public void setVehiclePlate(String vehiclePlate)     { this.vehiclePlate = vehiclePlate; }
        public void setSlotNumber  (String slotNumber)       { this.slotNumber   = slotNumber;   }
        public void setEntryTime   (LocalDateTime entryTime) { this.entryTime    = entryTime;    }
        public void setExitTime    (LocalDateTime exitTime)  { this.exitTime     = exitTime;     }
        public void setDurationMins(long durationMins)       { this.durationMins = durationMins; }
        public void setStatus      (String status)           { this.status       = status;       }
        public void setNotes       (String notes)            { this.notes        = notes;        }
    }

