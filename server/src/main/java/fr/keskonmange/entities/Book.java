package fr.keskonmange.entities;

public class Book {

    private long id;
    private String name;
    private long ownerId;
    private boolean visibility;

    public Book(long id, String name, long ownerId, boolean visibility) {
        this.id = id;
        this.name = name;
        this.ownerId = ownerId;
        this.visibility = visibility;
    }

    public Book(String name, long ownerId, boolean visibility) {
        this.name = name;
        this.ownerId = ownerId;
        this.visibility = visibility;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public long getOwnerId() {
        return ownerId;
    }

    public boolean isPublic() {
        return visibility;
    }
}
