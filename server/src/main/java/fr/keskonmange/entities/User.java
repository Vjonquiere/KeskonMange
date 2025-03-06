package fr.keskonmange.entities;

import java.time.LocalDate;

public class User {

    private long id;
    private String email;
    private String username;
    private LocalDate verified;

    public User() {}

    public User(long id, String email, String username, LocalDate verified) {
        this.id = id;
        this.email = email;
        this.username = username;
        this.verified = verified;
    }

    public long getId(){
        return id;
    }

    public String getEmail(){
        return email;
    }

    public void setEmail(String username){
        this.username = username;
    }

    public boolean isVerified(){
        return verified != null;
    }

    public void setVerified(LocalDate verified){
        this.verified = verified;
    }

    public String getUsername(){
        return username;
    }

    public void setUsername(String username){
        this.username = username;
    }


}
