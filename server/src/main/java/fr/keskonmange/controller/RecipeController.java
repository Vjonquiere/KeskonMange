package fr.keskonmange.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/recipe")
public class RecipeController {

    @GetMapping("/image")
    public String getRecipeImage(@RequestParam("recipeId") int recipeId, @RequestParam("format") String format) {
        return "success";
    }

    @GetMapping("/last")
    public String getLastRecipe() {
        return "success";
    }

    @GetMapping("/steps")
    public String getRecipeSteps(@RequestParam("recipeId") int recipeId) {
        return "success";
    }

    @GetMapping("/{id}")
    public String getRecipe(@PathVariable int id) {
        return "success";
    }

    @PostMapping("/add")
    public String addNewRecipe() {
        return "success";
    }

    @PostMapping("/image")
    public String addRecipeImage(@RequestParam("recipeId") int recipeId) {
        return "success";
    }

    @PostMapping("/steps")
    public String addRecipeStep(@RequestParam("recipeId") int recipeId) {
        return "success";
    }
}
