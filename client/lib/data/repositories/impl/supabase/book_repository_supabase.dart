import 'package:client/data/repositories/book_repository.dart';
import 'package:client/model/book/complete.dart';
import 'package:client/model/book/preview.dart';
import 'package:client/model/user.dart';

class BookRepositorySupabase extends BookRepository {
  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) {
    // TODO: implement addRecipeToBook
    throw UnimplementedError();
  }

  @override
  Future<int> createNewBook(BookPreview book) {
    // TODO: implement createNewBook
    throw UnimplementedError();
  }

  @override
  Future<int> deleteBook(int bookId) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }

  @override
  Future<int> deleteRecipeFromBook(int bookId, int recipeId) {
    // TODO: implement deleteRecipeFromBook
    throw UnimplementedError();
  }

  @override
  Future<Book?> getBook(int bookId) {
    // TODO: implement getBook
    throw UnimplementedError();
  }

  @override
  Future<List<BookPreview>> getUserBooks(User user) {
    // TODO: implement getUserBooks
    throw UnimplementedError();
  }
}
