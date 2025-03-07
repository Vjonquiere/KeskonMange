package fr.keskonmange.controller;

import fr.keskonmange.exceptions.IllegalContentAccess;
import fr.keskonmange.exceptions.NoContentException;
import fr.keskonmange.services.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/books")
public class RecipeBookController {

    @Autowired
    private BookService bookService;

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
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.userHasReadAccess(bookId, 1L)) throw new IllegalContentAccess("User does not have access to this book");
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
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.isOwner(bookId, 1L)) throw new IllegalContentAccess("Only owner can delete the book");
        return "success";
    }

    @DeleteMapping("/share")
    public String deleteShareLink(@RequestParam("bookId") int bookId, @RequestParam("userId") int userId) {
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.isOwner(bookId, 1L)) throw new IllegalContentAccess("Only owner can share the book");
        return "success";
    }
}
