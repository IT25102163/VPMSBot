public class Vehicle {
    private String vehicleNo;
    private String vehicleType;
    private int    userId;     // links vehicle to its owner (user_id)


    public String getVehicleNo()   { return vehicleNo;   }
    public String getVehicleType() { return vehicleType; }
    public int    getUserId()      { return userId;      }


    public void setVehicleNo  (String vehicleNo)   { this.vehicleNo   = vehicleNo;   }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public void setUserId     (int userId)        { this.userId      = userId;      }
}

