package fr.keskonmange.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {

    @GetMapping("/availableEmail")
    public String getAvailableEmail(@RequestParam("email") String email) {
        return "success";
    }

    @GetMapping("/availableUsername")
    public String getAvailableUsername(@RequestParam("username") String username) {
        return "success";
    }

    @PostMapping("/allergens")
    public String addAllergens(@RequestParam("email") String email) {
        return "success";
    }

    @PostMapping("/create")
    public String addUser(@RequestParam("email") String email, @RequestParam("username") String username) {
        return "success";
    }

    @PostMapping("/verify")
    public String verifyUser(@RequestParam("email") String email, @RequestParam("code") int code) {
        return "success";
    }
}
