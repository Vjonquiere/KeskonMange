package fr.keskonmange.controller;

import fr.keskonmange.entities.Book;
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
        if (!bookService.userHasReadAccess(bookId, 1L)) throw new IllegalContentAccess("User does not have access to this book"); // TODO: put userId
        return "success";
    }

    @PostMapping("/create")
    public String createBook(@RequestParam("name") String name, @RequestParam("visibility") boolean visibility) {
        // TODO: add name regex
        bookService.createBook(new Book(name, 1L, visibility)); // TODO: put userId
        return "success";
    }

    @PostMapping("/recipe/add")
    public String addRecipeToBook(@RequestParam("bookId") int bookId, @RequestParam("recipeId") int recipeId) {
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.isOwner(bookId, 1L)) throw new IllegalContentAccess("Cannot add recipe to this book"); // TODO: put userId
        if (!bookService.isRecipeInBook(bookId, recipeId)) throw new IllegalArgumentException("Recipe is already in this book");
        bookService.addRecipeToBook(bookId, recipeId);
        return "success";
    }

    @PostMapping("/share")
    public String createShareLink(@RequestParam("bookId") int bookId, @RequestParam("userId") int userId) {
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.isOwner(bookId, 1L)) throw new IllegalContentAccess("Cannot share not owned book"); // TODO: put userId
        bookService.shareBook(bookId, userId);
        return "success";
    }

    @DeleteMapping("/delete")
    public String deleteBook(@RequestParam("bookId") int bookId) {
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.isOwner(bookId, 1L)) throw new IllegalContentAccess("Only owner can delete the book");
        bookService.deleteAllShareLinks(bookId);
        bookService.removeAllRecipes(bookId);
        bookService.deleteBook(bookId);
        return "success";
    }

    @DeleteMapping("/share")
    public String deleteShareLink(@RequestParam("bookId") int bookId, @RequestParam("userId") int userId) {
        if (!bookService.bookExists(bookId)) throw new NoContentException("Book does not exist");
        if (!bookService.isOwner(bookId, 1L)) throw new IllegalContentAccess("Only owner can share the book");
        return "success";
    }
}
