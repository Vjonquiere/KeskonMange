package fr.keskonmange.repositories;

import fr.keskonmange.entities.Allergen;
import fr.keskonmange.entities.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Repository
public class AllergenRepository {
    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<Allergen> AllergenMapper = (rs, rowNum) -> new Allergen(
            rs.getLong("allergenId"),
            rs.getLong("userId")

    );

    public AllergenRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Allergen> getUserAllergens(User user) {
        return jdbcTemplate.query("SELECT allergenId, userId FROM allergens WHERE userId = ?", AllergenMapper , user.getId());
    }

    public void deleteUserAllergens(User user) {
        jdbcTemplate.update("DELETE FROM allergens WHERE userId = ?", user.getId());
    }

    public void setUserAllergens(User user, List<Integer> allergensIds) {
        for (Integer id : allergensIds) {
            jdbcTemplate.update("INSERT INTO allergens (userId, allergenId) VALUES (?, ?)", user.getId(), id);
        }
    }

    public void updateUserAllergens(User user, List<Integer> allergensIds) {
        deleteUserAllergens(user);
        setUserAllergens(user, allergensIds);
    }




}
