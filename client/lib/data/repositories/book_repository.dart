abstract class BookRepository {
  Future<int> createNewBook(String name);
  Future<int> addRecipeToBook(int bookId, int recipeId);
}
