package isuru;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ParkingSession - Represents one parking event (entry to exit)
 *
 * OOP Concepts:
 *   INHERITANCE  : Extends ParkingRecord
 *   POLYMORPHISM : Overrides getRecordType() and getSummary()
 *   ENCAPSULATION: All fields private with getters/setters
 */
public class ParkingSession extends ParkingRecord {

    private String slotNumber;
    private LocalDateTime entryTime;
    private LocalDateTime exitTime;
    private long durationMins;
    private String status;   // ACTIVE | COMPLETED | CANCELLED
    private String notes;

    private static final DateTimeFormatter FMT =
            DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");

    // Default constructor
    public ParkingSession() {
        super();
    }

    // Full constructor
    public ParkingSession(int id, String vehiclePlate, String slotNumber,
                          LocalDateTime entryTime, LocalDateTime exitTime,
                          long durationMins, String status, String notes,
                          LocalDateTime createdAt) {
        super(id, vehiclePlate, createdAt);
        this.slotNumber   = slotNumber;
        this.entryTime    = entryTime;
        this.exitTime     = exitTime;
        this.durationMins = durationMins;
        this.status       = status;
        this.notes        = notes;
    }

    // POLYMORPHISM - overriding abstract methods from ParkingRecord
    @Override
    public String getRecordType() {
        return "Parking Session";
    }

    @Override
    public String getSummary() {
        return "Vehicle " + vehiclePlate
                + " | Slot " + slotNumber
                + " | " + status
                + " | Duration: " + formatDuration();
    }

    // Auto-calculate duration from entry/exit times
    public void calculateDuration() {
        if (entryTime != null && exitTime != null) {
            this.durationMins = Duration.between(entryTime, exitTime).toMinutes();
        }
    }

    // Returns duration as "2h 30m" format
    public String formatDuration() {
        if (durationMins <= 0) return "In Progress";
        long hours   = durationMins / 60;
        long minutes = durationMins % 60;
        if (hours == 0) return minutes + "m";
        return hours + "h " + minutes + "m";
    }

    // Formatted times for JSP display
    public String getFormattedEntryTime() {
        return (entryTime != null) ? entryTime.format(FMT) : "-";
    }

    public String getFormattedExitTime() {
        return (exitTime != null) ? exitTime.format(FMT) : "Still Parked";
    }

    // Bootstrap badge color based on status
    public String getStatusBadgeClass() {
        if (status == null) return "secondary";
        switch (status) {
            case "ACTIVE":    return "success";
            case "COMPLETED": return "primary";
            case "CANCELLED": return "danger";
            default:          return "secondary";
        }
    }

    // Getters and Setters (ENCAPSULATION)
    public String getSlotNumber()               { return slotNumber; }
    public void setSlotNumber(String s)         { this.slotNumber = s; }

    public LocalDateTime getEntryTime()         { return entryTime; }
    public void setEntryTime(LocalDateTime t)   { this.entryTime = t; }

    public LocalDateTime getExitTime()          { return exitTime; }
    public void setExitTime(LocalDateTime t)    { this.exitTime = t; }

    public long getDurationMins()               { return durationMins; }
    public void setDurationMins(long d)         { this.durationMins = d; }

    public String getStatus()                   { return status; }
    public void setStatus(String s)             { this.status = s; }

    public String getNotes()                    { return notes; }
    public void setNotes(String n)              { this.notes = n; }
}
