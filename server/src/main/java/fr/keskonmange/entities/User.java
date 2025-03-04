package fr.keskonmange.entities;

import jakarta.persistence.*;

import java.util.Calendar;

@Entity
@Table(name="user")
public class User {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private long id;
    private String email;
    private String username;
    @Temporal(TemporalType.DATE)
    private Calendar verified;

    public void setVerified() {
        verified = Calendar.getInstance();
    }

    public long getId() {
        return id;
    }
}
