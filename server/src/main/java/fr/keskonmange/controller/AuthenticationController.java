package fr.keskonmange.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthenticationController {

    @PostMapping("/signin")
    public String signin(@RequestParam("email") String email, @RequestParam("lang") String lang, @RequestParam(value = "code", required = false) int code) {
        return "success";
    }

    @PostMapping("/test")
    public String test(@RequestParam("email") String email, @RequestParam("api_key") String api_key) {
        return "success";
    }

    @PostMapping("/logout")
    public String logout(@RequestParam("email") String email, @RequestParam("api_key") String api_key) {
        return "success";
    }
}
