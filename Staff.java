package Parking;

/**
 * Staff.java
 * Represents a staff member who works at the parking facility
 * These are NOT vehicle owners (Users) — they are employees
 * Examples: Security Guard, Billing Staff, Parking Attendant
 */
public class Staff {

    private int    staffId;
    private String name;
    private String email;
    private String phone;
    private String position;     // Security Guard, Billing Staff, Attendant, Manager
    private String permissions;  // entry_exit, billing, admin, all

    // Constructor with ID (reading from DB)
    public Staff(int staffId, String name, String email,
                 String phone, String position, String permissions) {
        this.staffId     = staffId;
        this.name        = name;
        this.email       = email;
        this.phone       = phone;
        this.position    = position;
        this.permissions = permissions;
    }

    // Constructor without ID (creating new)
    public Staff(String name, String email,
                 String phone, String position, String permissions) {
        this.name        = name;
        this.email       = email;
        this.phone       = phone;
        this.position    = position;
        this.permissions = permissions;
    }

    public int    getStaffId()     { return staffId;     }
    public String getName()        { return name;        }
    public String getEmail()       { return email;       }
    public String getPhone()       { return phone;       }
    public String getPosition()    { return position;    }
    public String getPermissions() { return permissions; }

    public void setStaffId    (int id)     { this.staffId     = id;          }
    public void setName       (String s)   { this.name        = s;           }
    public void setEmail      (String s)   { this.email       = s;           }
    public void setPhone      (String s)   { this.phone       = s;           }
    public void setPosition   (String s)   { this.position    = s;           }
    public void setPermissions(String s)   { this.permissions = s;           }
}
