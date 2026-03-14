import java.sql.Connection;
import java.sql.DriverManager;

    public class DBConnection {

        
        private static final String URL      = "jdbc:mysql://localhost:3306/parking_system";
        private static final String USERNAME = "root";
        private static final String PASSWORD = "";  

    
        public static Connection getConnection() {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                return DriverManager.getConnection(URL, USERNAME, PASSWORD);

            } catch (Exception e) {
               
                System.out.println("Database connection failed: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
        }
    }
   

