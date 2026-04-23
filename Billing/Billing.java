package Parking;

public class Billing {

        private int    id;
        private String vehicleNo;
        private double amount;
        private String paymentMethod;
        private String status;

        // Constructor with ID (reading from database)
        public Billing(int id, String vehicleNo, double amount, String paymentMethod, String status) {
            this.id            = id;
            this.vehicleNo     = vehicleNo;
            this.amount        = amount;
            this.paymentMethod = paymentMethod;
            this.status        = status;
        }

        // Constructor without ID (creating new record)
        public Billing(String vehicleNo, double amount, String paymentMethod, String status) {
            this.vehicleNo     = vehicleNo;
            this.amount        = amount;
            this.paymentMethod = paymentMethod;
            this.status        = status;
        }

        public int    getId()            { return id;            }
        public String getVehicleNo()     { return vehicleNo;     }
        public double getAmount()        { return amount;        }
        public String getPaymentMethod() { return paymentMethod; }
        public String getStatus()        { return status;        }

        public void setId           (int id)           { this.id            = id;     }
        public void setVehicleNo    (String vehicleNo) { this.vehicleNo     = vehicleNo; }
        public void setAmount       (double amount)    { this.amount        = amount; }
        public void setPaymentMethod(String method)    { this.paymentMethod = method; }
        public void setStatus       (String status)    { this.status        = status; }
    }

