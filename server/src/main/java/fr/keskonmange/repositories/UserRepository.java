package fr.keskonmange.repositories;

import fr.keskonmange.entities.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserRepository {
    private final JdbcTemplate jdbcTemplate;

    public UserRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public User getById(long id){
        return new User();
    }

    public User getByEmail(String email){
        return new User();
    }

    public void setVerified(long userId) {

    }
}
