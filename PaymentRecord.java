package Parking;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * PaymentRecord - Represents a payment linked to a parking session
 *
 * OOP Concepts:
 *   INHERITANCE  : Extends ParkingRecord
 *   POLYMORPHISM : Overrides getRecordType() and getSummary()
 *   ENCAPSULATION: All fields private with getters/setters
 */
public class PaymentRecord extends ParkingRecord {

    private int sessionId;
    private double amount;
    private String paymentMethod;   // CASH | CARD | ONLINE
    private LocalDateTime paymentTime;
    private double ratePerHour;

    private static final DateTimeFormatter FMT =
            DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");

    // Default constructor
    public PaymentRecord() {
        super();
    }

    // Full constructor
    public PaymentRecord(int id, String vehiclePlate, int sessionId,
                         double amount, String paymentMethod,
                         LocalDateTime paymentTime, double ratePerHour,
                         LocalDateTime createdAt) {
        super(id, vehiclePlate, createdAt);
        this.sessionId     = sessionId;
        this.amount        = amount;
        this.paymentMethod = paymentMethod;
        this.paymentTime   = paymentTime;
        this.ratePerHour   = ratePerHour;
    }

    // POLYMORPHISM - overriding abstract methods
    @Override
    public String getRecordType() {
        return "Payment";
    }

    @Override
    public String getSummary() {
        return "Vehicle " + vehiclePlate
                + " | LKR " + String.format("%.2f", amount)
                + " | " + paymentMethod;
    }

    // Formatted payment time for JSP display
    public String getFormattedPaymentTime() {
        return (paymentTime != null) ? paymentTime.format(FMT) : "-";
    }

    // Bootstrap badge color based on payment method
    public String getMethodBadgeClass() {
        if (paymentMethod == null) return "secondary";
        switch (paymentMethod) {
            case "CASH":   return "success";
            case "CARD":   return "primary";
            case "ONLINE": return "info";
            default:       return "secondary";
        }
    }

    // Getters and Setters (ENCAPSULATION)
    public int getSessionId()                   { return sessionId; }
    public void setSessionId(int s)             { this.sessionId = s; }

    public double getAmount()                   { return amount; }
    public void setAmount(double a)             { this.amount = a; }

    public String getPaymentMethod()            { return paymentMethod; }
    public void setPaymentMethod(String m)      { this.paymentMethod = m; }

    public LocalDateTime getPaymentTime()       { return paymentTime; }
    public void setPaymentTime(LocalDateTime t) { this.paymentTime = t; }

    public double getRatePerHour()              { return ratePerHour; }
    public void setRatePerHour(double r)        { this.ratePerHour = r; }
}
