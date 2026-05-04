package Parking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

    public class ReportDAO {

        // GENERATE (Report)
        public void addReport(Report report) throws SQLException {
            String sql = "INSERT INTO reports(description, generated_by) VALUES(?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, report.getDescription());
                stmt.setString(2, report.getGeneratedBy());
                stmt.executeUpdate();
            }
        }

        // Get all reports
        public List<Report> getAllReports() throws SQLException {
            List<Report> reports = new ArrayList<>();
            String sql = "SELECT * FROM reports";

            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {

                while (rs.next()) {
                    Report report = new Report(
                            rs.getInt("report_id"),
                            rs.getString("description"),
                            rs.getTimestamp("date"),
                            rs.getString("generated_by")
                    );
                    reports.add(report);
                }
            }
            return reports;
        }

        // Get report by ID
        public Report getReportById(int reportId) throws SQLException {
            String sql = "SELECT * FROM reports WHERE report_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, reportId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return new Report(
                                rs.getInt("report_id"),
                                rs.getString("description"),
                                rs.getTimestamp("date"),
                                rs.getString("generated_by")
                        );
                    }
                }
            }
            return null;
        }

        // Update (Admin only)
        public void updateReport(Report report) throws SQLException {
            String sql = "UPDATE reports SET description=?, generated_by=? WHERE report_id=?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, report.getDescription());
                stmt.setString(2, report.getGeneratedBy());
                stmt.setInt(3, report.getReportId());
                stmt.executeUpdate();
            }
        }

        // Remove incorrect report
        public void deleteReport(int reportId) throws SQLException {
            String sql = "DELETE FROM reports WHERE report_id=?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, reportId);
                stmt.executeUpdate();
            }
        }

        // Search reports by date
        public List<Report> getReportsByDate(Date date) throws SQLException {
            List<Report> reports = new ArrayList<>();
            String sql = "SELECT * FROM reports WHERE DATE(date) = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setDate(1, date);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Report report = new Report(
                                rs.getInt("report_id"),
                                rs.getString("description"),
                                rs.getTimestamp("date"),
                                rs.getString("generated_by")
                        );
                        reports.add(report);
                    }
                }
            }
            return reports;
        }
    }

