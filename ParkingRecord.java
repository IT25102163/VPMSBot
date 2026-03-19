package isuru;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ParkingRecord - Abstract Base Class
 *
 * OOP Concepts:
 *   ABSTRACTION  : Cannot be instantiated directly
 *   ENCAPSULATION: All fields private/protected, accessed via getters/setters
 *   INHERITANCE  : ParkingSession and PaymentRecord both extend this class
 */
public abstract class ParkingRecord {

    // Protected fields — subclasses can access these
    protected int id;
    protected String vehiclePlate;
    protected LocalDateTime createdAt;

    private static final DateTimeFormatter DISPLAY_FMT =
            DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");

    // Default constructor
    public ParkingRecord() {}

    // Parameterized constructor
    public ParkingRecord(int id, String vehiclePlate, LocalDateTime createdAt) {
        this.id           = id;
        this.vehiclePlate = vehiclePlate;
        this.createdAt    = createdAt;
    }

    // Abstract methods — each subclass must implement these (POLYMORPHISM)
    public abstract String getRecordType();
    public abstract String getSummary();

    // Shared method — formats date for display in JSP
    public String getFormattedCreatedAt() {
        return (createdAt != null) ? createdAt.format(DISPLAY_FMT) : "-";
    }

    // Getters and Setters (ENCAPSULATION)
    public int getId()                        { return id; }
    public void setId(int id)                 { this.id = id; }

    public String getVehiclePlate()           { return vehiclePlate; }
    public void setVehiclePlate(String v)     { this.vehiclePlate = v; }

    public LocalDateTime getCreatedAt()       { return createdAt; }
    public void setCreatedAt(LocalDateTime t) { this.createdAt = t; }

    @Override
    public String toString() {
        return "[" + getRecordType() + "] id=" + id + ", plate=" + vehiclePlate;
    }
}
