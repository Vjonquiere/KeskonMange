package fr.keskonmange.services;

import fr.keskonmange.entities.Book;
import fr.keskonmange.repositories.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class BookService {
    @Autowired
    private BookRepository bookRepository;

    public boolean bookExists(long bookId) {
        return bookRepository.getBookById(bookId) != null;
    }

    public boolean userHasReadAccess(long bookId, long userId){
        return bookRepository.isPublic(bookId) || bookRepository.isOwner(bookId, userId) || bookRepository.hasAuthorization(bookId, userId);
    }

    public boolean isOwner(long bookId, long userId){
        return bookRepository.isOwner(bookId, userId);
    }

    public void createBook(Book book) {
        bookRepository.createBook(book);
    }

    public void deleteBook(long bookId) {
        bookRepository.deleteBook(bookId);
    }

    public void deleteShareLink(long bookId, long userId) {
        bookRepository.removeShareLink(bookId, userId);
    }

    public void deleteAllShareLinks(long bookId) {
        bookRepository.removeAllShareLinks(bookId);
    }

    public void shareBook(long bookId, long shareWithUserId) {
        bookRepository.shareBook(bookId, shareWithUserId);
    }

    public List<Integer> getRecipes(long bookId){
        return bookRepository.getRecipes(bookId);
    }

    public void removeAllRecipes(long bookId) {
        bookRepository.removeAllRecipes(bookId);
    }

    public Integer getRecipeCount(long bookId){
        return bookRepository.getNumberOfRecipes(bookId);
    }

    public void addRecipeToBook(long bookId, int recipeId) {
        bookRepository.linkRecipe(bookId, recipeId);
    }

    public boolean isRecipeInBook(long bookId, long recipeId) {
        return bookRepository.isRecipeInBook(bookId, recipeId);
    }


}
