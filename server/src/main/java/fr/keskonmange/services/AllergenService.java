package fr.keskonmange.services;

import fr.keskonmange.entities.Allergen;
import fr.keskonmange.entities.User;
import fr.keskonmange.repositories.AllergenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AllergenService {
    @Autowired
    private AllergenRepository allergenRepository;

    public List<Allergen> getUserAllergens(User user) {
        return allergenRepository.getAllergensByUsers(user);
    }

    public List<Allergen> setUserAllergens(User user, List<Integer> allergensIds) {
        List<Allergen> userAllergens = allergenRepository.getAllergensByUsers(user);
        return new ArrayList<>();
    }
}
