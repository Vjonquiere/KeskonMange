package fr.keskonmange.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/books")
public class RecipeBookController {

    @GetMapping("/general_information")
    public String getGeneralInformation(@RequestParam("bookId") int bookId) {
        return "success";
    }

    @GetMapping("/id")
    public String getBookId(@RequestParam("name") String name) {
        return "success";
    }

    @GetMapping("/recipes")
    public String getBookRecipes(@RequestParam("bookId") int bookId) {
        return "success";
    }

    @PostMapping("/create")
    public String createBook(@RequestParam("name") String name) {
        return "success";
    }

    @PostMapping("/recipe/add")
    public String addRecipeToBook(@RequestParam("bookId") int bookId, @RequestParam("recipeId") int recipeId) {
        return "success";
    }

    @PostMapping("/share")
    public String createShareLink(@RequestParam("bookId") int bookId, @RequestParam("userId") int userId) {
        return "success";
    }

    @DeleteMapping("/delete")
    public String deleteBook(@RequestParam("bookId") int bookId) {
        return "success";
    }

    @DeleteMapping("/share")
    public String deleteShareLink(@RequestParam("bookId") int bookId, @RequestParam("userId") int userId) {
        return "success";
    }
}
