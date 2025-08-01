package fr.keskonmange.entities;

public class Allergen {

    private long allergenId;
    private long userId;

    public Allergen() {}

    public Allergen(long allergenId, long userId) {
        this.allergenId = allergenId;
        this.userId = userId;
    }

    public long getAllergenId() {
        return allergenId;
    }

    public void setAllergenId(long allergenId) {
        this.allergenId = allergenId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
