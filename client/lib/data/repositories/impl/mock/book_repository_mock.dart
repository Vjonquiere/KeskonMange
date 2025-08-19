import 'package:client/data/repositories/book_repository.dart';
import 'package:client/model/user.dart';

import '../../../../model/book/complete.dart';
import '../../../../model/book/preview.dart';

class BookRepositoryMock extends BookRepository {
  List<Book> books = [];

  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) async {
    for (Book book in books) {
      if (book.id == bookId) {
        book.recipesIds.add(recipeId);
        return 200;
      }
    }
    return 200;
  }

  @override
  Future<int> createNewBook(BookPreview book) async {
    books.add(Book.fromPreview(book));
    return 200;
  }

  @override
  Future<Book?> getBook(int bookId) async {
    for (Book book in books) {
      if (book.id == bookId) {
        return book;
      }
    }
    return null;
  }

  @override
  Future<List<BookPreview>> getUserBooks(User user) async {
    return books;
  }
}
