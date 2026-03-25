package Billing;

public class Feedback {
    private int id;
    private int userId;
    private String message;
    private int rating;

    public Feedback(int id, int userId, String message, int rating) {
        this.id = id;
        this.userId = userId;
        this.message = message;
        this.rating = rating;
    }

    public Feedback(int userId, String message, int rating) {
        this.userId = userId;
        this.message = message;
        this.rating = rating;
    }

    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getMessage() { return message; }
    public int getRating() { return rating; }
}
