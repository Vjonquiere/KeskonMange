package fr.keskonmange.services;

import fr.keskonmange.entities.Allergen;
import fr.keskonmange.entities.User;
import fr.keskonmange.repositories.AllergenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AllergenService {
    @Autowired
    private AllergenRepository allergenRepository;

    public List<Allergen> getUserAllergens(User user) {
        return allergenRepository.getUserAllergens(user);
    }

    public void setUserAllergens(User user, List<Integer> allergensIds) {
       allergenRepository.updateUserAllergens(user, allergensIds);
    }
}
