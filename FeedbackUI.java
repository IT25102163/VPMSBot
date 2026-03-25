package Billing;

import com.parksmart.billing.dao.ParkingLotDAO;
import com.parksmart.billing.model.Feedback;

import javax.swing.*;
import java.awt.*;

public class FeedbackUI extends JFrame {

    private ParkingLotDAO dao = new ParkingLotDAO();

    public FeedbackUI() {
        setTitle("Feedback System");
        setSize(400,300);
        setLayout(new GridLayout(5,2));

        JTextField userIdField = new JTextField();
        JTextArea messageArea = new JTextArea();
        JComboBox<Integer> ratingBox = new JComboBox<>(new Integer[]{1,2,3,4,5});

        JButton submitBtn = new JButton("Submit");

        add(new JLabel("User ID"));
        add(userIdField);
        add(new JLabel("Message"));
        add(new JScrollPane(messageArea));
        add(new JLabel("Rating"));
        add(ratingBox);
        add(new JLabel(""));
        add(submitBtn);

        submitBtn.addActionListener(e -> {
            dao.saveFeedback(new Feedback(
                    Integer.parseInt(userIdField.getText()),
                    messageArea.getText(),
                    (Integer) ratingBox.getSelectedItem()
            ));

            JOptionPane.showMessageDialog(this, "Feedback Submitted!");
        });

        setVisible(true);
    }

    public static void main(String[] args) {
        new FeedbackUI();
    }
}
