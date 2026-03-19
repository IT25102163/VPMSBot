package isuru;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * DBConnection - Shared database connection utility
 * 
 * IMPORTANT: Charya will update the credentials here.
 * Everyone uses this same file from GitHub.
 * 
 * OOP Concept: ENCAPSULATION - hides connection details from other classes
 */
public class DBConnection {

    private static final String URL  = "jdbc:mysql://localhost:3306/parksmart_db";
    private static final String USER = "root";
    private static final String PASS = "";  // XAMPP default = empty password

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            System.err.println("DB Connection failed: " + e.getMessage());
            return null;
        }
    }

    // Safely close connection without throwing exceptions
    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (Exception ignored) {}
        }
    }
}
