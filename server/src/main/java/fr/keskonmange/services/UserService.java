package fr.keskonmange.services;

import fr.keskonmange.entities.Allergen;
import fr.keskonmange.entities.User;
import fr.keskonmange.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User getUserById(long id) {
        return userRepository.getById(id);
    }

    public User getUserByEmail(String email) {
        return userRepository.getByEmail(email);
    }

    public void setVerified(long userId) {
        userRepository.setVerified(userId);
    }

}
