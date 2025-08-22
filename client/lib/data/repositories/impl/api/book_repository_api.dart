import 'package:client/data/repositories/book_repository.dart';
import 'package:client/http/books/AddRecipeToBookRequest.dart';
import 'package:client/http/books/CreateNewBookRequest.dart';
import 'package:client/model/book/preview.dart';
import 'package:client/model/user.dart';

import '../../../../model/book/complete.dart';

class BookRepositoryApi extends BookRepository {
  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) async {
    return (await AddRecipeToBookRequest(recipeId, bookId).send());
  }

  @override
  Future<int> createNewBook(BookPreview book) async {
    return (await CreateNewBookRequest(book.name).send());
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

  @override
  Future<int> deleteBook(int bookId) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }
}
