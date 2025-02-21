package fr.keskonmange.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ingredient")
public class IngredientController {

    @GetMapping("/name")
    public String getIngredientFromName(@RequestParam("name") String name) {
        return "success";
    }

    @GetMapping("/units")
    public String getIngredientUnits(@RequestParam("name") String name) {
        return "success";
    }

    @PostMapping("/add")
    public String addNewIngredient(@RequestParam("name") String name, @RequestParam("type") String type) {
        return "success";
    }
}
