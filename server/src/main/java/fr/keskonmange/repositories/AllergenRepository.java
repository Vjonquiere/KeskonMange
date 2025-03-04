package fr.keskonmange.repositories;

import fr.keskonmange.entities.Allergen;
import fr.keskonmange.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AllergenRepository extends JpaRepository<Allergen, Long> {
    List<Allergen> getAllergensByUsers(User users);
}
