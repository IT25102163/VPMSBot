package Parking;
import java.sql.Connection;
import java.sql.DriverManager;


public class DBConnection {

    private static final String URL  = "jdbc:mysql://localhost:3307/parking_system";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            System.err.println("DB Connection failed: " + e.getMessage());
            return null;
        }
    }

    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (Exception ignored) {}
        }
    }
}

