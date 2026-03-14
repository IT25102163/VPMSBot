import java.sql.Connection;
import java.sql.DriverManager;

    public class DBConnection {

        // ── Database settings ──────────────────────
        // These match XAMPP defaults. Do NOT change.
        private static final String URL      = "jdbc:mysql://localhost:3306/parking_system";
        private static final String USERNAME = "root";
        private static final String PASSWORD = "";  // XAMPP has no password by default

        // ── getConnection() ────────────────────────
        // Call this method in your DAO classes to
        // open a connection to the MySQL database.
        // Example: Connection con = DBConnection.getConnection();
        public static Connection getConnection() {
            try {
                // Load the MySQL driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Open and return the connection
                return DriverManager.getConnection(URL, USERNAME, PASSWORD);

            } catch (Exception e) {
                // Print error to console if connection fails
                System.out.println("Database connection failed: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
        }
    }
   

