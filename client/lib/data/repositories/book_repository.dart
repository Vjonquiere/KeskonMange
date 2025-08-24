import '../../model/book/complete.dart';
import '../../model/book/preview.dart';
import '../../model/user.dart';

abstract class BookRepository {
  Future<int> createNewBook(BookPreview book);
  Future<int> addRecipeToBook(int bookId, int recipeId);
  Future<List<BookPreview>> getUserBooks(User user);
  Future<Book?> getBook(int bookId);
  Future<int> deleteBook(int bookId);
  Future<int> deleteRecipeFromBook(int bookId, int recipeId);
}
