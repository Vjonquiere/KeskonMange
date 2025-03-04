package fr.keskonmange.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "allergen")
public class Allergen {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private long allergenId;

    @ManyToOne
    private User users;

    public long getAllergenId() {
        return allergenId;
    }
}
