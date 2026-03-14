package home;

public class User {
    private int    userId;
    private String name;
    private String contact;
    private String username;
    private String password;
    private String role;

    // ── Getters (read the value) ───────────────
    public int    getUserId()   { return userId;   }
    public String getName()     { return name;     }
    public String getContact()  { return contact;  }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole()     { return role;     }

    // ── Setters (set the value) ────────────────
    public void setUserId  (int userId)       { this.userId   = userId;   }
    public void setName    (String name)     { this.name     = name;     }
    public void setContact (String contact)  { this.contact  = contact;  }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setRole    (String role)     { this.role     = role;     }
}

