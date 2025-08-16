import 'package:client/data/repositories/book_repository.dart';
import 'package:client/model/user.dart';

import '../../../../model/book/complete.dart';
import '../../../../model/book/preview.dart';

class BookRepositoryMock extends BookRepository {
  List<BookPreview> books = [];

  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) async {
    return 200;
  }

  @override
  Future<int> createNewBook(BookPreview book) async {
    books.add(book);
    return 200;
  }

  @override
  Future<Book> getBook(int bookId) {
    // TODO: implement getBook
    throw UnimplementedError();
  }

  @override
  Future<List<BookPreview>> getUserBooks(User user) async {
    return books;
  }
}
