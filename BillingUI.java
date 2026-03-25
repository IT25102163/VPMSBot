package Billing;

import com.parksmart.billing.dao.ParkingLotDAO;
import com.parksmart.billing.model.Payment;

import javax.swing.*;
import java.awt.*;

public class BillingUI extends JFrame {

    private ParkingLotDAO dao = new ParkingLotDAO();

    public BillingUI() {
        setTitle("ParkSmart Billing System");
        setSize(400, 300);
        setLayout(new GridLayout(6,2));

        JTextField vehicleIdField = new JTextField();
        JTextField hoursField = new JTextField();
        JComboBox<String> methodBox = new JComboBox<>(new String[]{"Cash", "Card", "Online"});

        JLabel amountLabel = new JLabel("0");

        JButton calculateBtn = new JButton("Calculate");
        JButton payBtn = new JButton("Pay");

        add(new JLabel("Vehicle ID"));
        add(vehicleIdField);
        add(new JLabel("Hours"));
        add(hoursField);
        add(new JLabel("Payment Method"));
        add(methodBox);
        add(new JLabel("Amount"));
        add(amountLabel);
        add(calculateBtn);
        add(payBtn);

        // Calculate Bill
        calculateBtn.addActionListener(e -> {
            int hours = Integer.parseInt(hoursField.getText());
            double amount = dao.calculateBill(hours);
            amountLabel.setText(String.valueOf(amount));
        });

        // Save Payment
        payBtn.addActionListener(e -> {
            int vehicleId = Integer.parseInt(vehicleIdField.getText());
            double amount = Double.parseDouble(amountLabel.getText());
            String method = (String) methodBox.getSelectedItem();

            dao.savePayment(new Payment(vehicleId, amount, method, "PAID"));

            JOptionPane.showMessageDialog(this, "Payment Successful!");
        });

        setVisible(true);
    }

    public static void main(String[] args) {
        new BillingUI();
    }
}
