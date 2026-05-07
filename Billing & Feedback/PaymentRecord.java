package Parking;

import java.time.LocalDateTime;

    public class PaymentRecord {
        private int           id;
        private int           sessionId;
        private String        vehiclePlate;
        private double        amount;
        private String        paymentMethod;
        private double        ratePerHour;
        private LocalDateTime paymentTime;
        private LocalDateTime createdAt;

        public int           getId()            { return id;            }
        public int           getSessionId()     { return sessionId;     }
        public String        getVehiclePlate()  { return vehiclePlate;  }
        public double        getAmount()        { return amount;        }
        public String        getPaymentMethod() { return paymentMethod; }
        public double        getRatePerHour()   { return ratePerHour;   }
        public LocalDateTime getPaymentTime()   { return paymentTime;   }
        public LocalDateTime getCreatedAt()     { return createdAt;     }

        public void setId           (int id)                    { this.id            = id;            }
        public void setSessionId    (int sessionId)             { this.sessionId     = sessionId;     }
        public void setVehiclePlate (String vehiclePlate)       { this.vehiclePlate  = vehiclePlate;  }
        public void setAmount       (double amount)             { this.amount        = amount;        }
        public void setPaymentMethod(String paymentMethod)      { this.paymentMethod = paymentMethod; }
        public void setRatePerHour  (double ratePerHour)        { this.ratePerHour   = ratePerHour;   }
        public void setPaymentTime  (LocalDateTime paymentTime) { this.paymentTime   = paymentTime;   }
        public void setCreatedAt    (LocalDateTime createdAt)   { this.createdAt     = createdAt;     }
    }

