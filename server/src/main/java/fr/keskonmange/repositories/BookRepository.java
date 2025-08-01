package fr.keskonmange.repositories;

import fr.keskonmange.entities.Book;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Repository
public class BookRepository {
    private final JdbcTemplate jdbcTemplate;

    public BookRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Book> BookMapper = (rs, rowNum) -> new Book(
            rs.getLong("id"),
            rs.getString("name"),
            rs.getLong("owner"),
            rs.getBoolean("visibility")
    );

    public Book getBookById(long bookId) {
        return jdbcTemplate.queryForObject("SELECT * FROM recipe_books WHERE id = ?", BookMapper, bookId);
    }

    public boolean isPublic(long bookId) {
        return jdbcTemplate.queryForObject("SELECT * FROM recipe_books WHERE id = ? AND visibility = 1", BookMapper, bookId) == null;
    }

    public boolean isOwner(long bookId, long userId) {
        return jdbcTemplate.queryForObject("SELECT * FROM recipe_books WHERE id = ? AND owner = ?", BookMapper, bookId, userId) == null;
    }

    public boolean hasAuthorization(long bookId, long userId) {
        return jdbcTemplate.queryForObject("SELECT id FROM recipe_books JOIN recipe_book_access ON recipe_books.id = recipe_book_access.bookId WHERE recipe_book_access.bookId = ? AND recipe_book_access.userId = ?;", BookMapper, bookId, userId) != null;
    }

    public void createBook(Book book) {
        jdbcTemplate.update("INSERT INTO recipe_books(name, owner, visibility) VALUES (?, ?, ?)", book.getName(), book.getOwnerId(), book.isPublic());
    }

    public void deleteBook(long bookId) {
        jdbcTemplate.update("DELETE FROM recipe_books WHERE id = ?", bookId);
    }

    public void shareBook(long bookId, long userId) {
        jdbcTemplate.update("INSERT INTO recipe_book_access VALUES (?,?)", bookId, userId);
    }

    public void deleteBookAccess(long bookId, long userId) {
        jdbcTemplate.update("DELETE FROM recipe_book_access WHERE bookId = ? AND userId = ?", bookId, userId);
    }

    public List<Integer> getRecipes(long bookId){
        List<Map<String, Object>> query =  jdbcTemplate.queryForList("SELECT recipeId FROM recipe_book_links WHERE bookId = ?;", bookId);
        ArrayList<Integer> recipes = new ArrayList<>();
        for (Map<String, Object> recipe : query){
            if (!recipe.containsKey("id")) throw new IllegalArgumentException("Recipe id is missing");
            recipes.add(Integer.parseInt((String) recipe.get("recipeId")));
        }
        return recipes;
    }

    public Integer getNumberOfRecipes(long bookId){
        return jdbcTemplate.queryForObject("SELECT COUNT(bookId) FROM recipe_book_links WHERE bookId=?", Integer.class, bookId);
    }

    public void linkRecipe(long bookId, long recipeId) {
        jdbcTemplate.update("INSERT INTO recipe_book_links VALUES (?, ?, ?)", bookId, recipeId, LocalDate.now());
    }

    public boolean isRecipeInBook(long bookId, long recipeId) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM recipe_book_links WHERE bookId = ? AND recipeId = ?", Integer.class, bookId, recipeId) != 0;
    }

    public void removeAllRecipes(long bookId) {
        jdbcTemplate.update("DELETE FROM recipe_book_links WHERE bookId = ?", bookId);
    }

    public void removeAllShareLinks(long bookId) {
        jdbcTemplate.update("DELETE FROM recipe_book_access WHERE bookId = ?", bookId);
    }

    public void removeShareLink(long bookId, long userId) {
        jdbcTemplate.update("DELETE FROM recipe_book_access WHERE bookId = ? AND userId = ?", bookId, userId);
    }

}
