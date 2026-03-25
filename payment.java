package Billing;

public class payment {
    private int id;
    private int vehicleId;
    private double amount;
    private String paymentMethod;
    private String status;

    public payment(int id, int vehicleId, double amount, String paymentMethod, String status) {
        this.id = id;
        this.vehicleId = vehicleId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
    }

    public payment(int vehicleId, double amount, String paymentMethod, String status) {
        this.vehicleId = vehicleId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
    }

    public int getId() { return id; }
    public int getVehicleId() { return vehicleId; }
    public double getAmount() { return amount; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getStatus() { return status; }

    public void setAmount(double amount) { this.amount = amount; }
    public void setPaymentMethod(String method) { this.paymentMethod = method; }
    public void setStatus(String status) { this.status = status; }
}
