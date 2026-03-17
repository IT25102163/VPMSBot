package com.parksmart.admin.ui;

import javax.swing.*;
import java.awt.*;

public class AdminDashboard extends JFrame {
    public AdminDashboard() {
        setTitle("ParkSmart Admin Dashboard");
        setSize(800, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JTabbedPane tabbedPane = new JTabbedPane();

        tabbedPane.add("Users", new UserManagementPanel());
        tabbedPane.add("Parking Slots", new ParkingSlotPanel());
        tabbedPane.add("Staff", new StaffManagementPanel());
        tabbedPane.add("Reports", new ReportPanel());

        add(tabbedPane, BorderLayout.CENTER);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new AdminDashboard().setVisible(true));
    }
}
