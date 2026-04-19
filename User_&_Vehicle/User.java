package Parking;
public class User {


    private int    userId;
    private String name;
    private String contact;
    private String username;
    private String password;
    private String role;


    private String vehicleNo;
    private String vehicleType;


    public int    getUserId()     { return userId;      }
    public String getName()       { return name;        }
    public String getContact()    { return contact;     }
    public String getUsername()   { return username;    }
    public String getPassword()   { return password;    }
    public String getRole()       { return role;        }
    public String getVehicleNo()  { return vehicleNo;   }
    public String getVehicleType(){ return vehicleType; }


    public void setUserId    (int userId)        { this.userId      = userId;      }
    public void setName      (String name)       { this.name        = name;        }
    public void setContact   (String contact)    { this.contact     = contact;     }
    public void setUsername  (String username)   { this.username    = username;    }
    public void setPassword  (String password)   { this.password    = password;    }
    public void setRole      (String role)       { this.role        = role;        }
    public void setVehicleNo (String vehicleNo)  { this.vehicleNo   = vehicleNo;   }
    public void setVehicleType(String vehicleType){ this.vehicleType = vehicleType; }
}