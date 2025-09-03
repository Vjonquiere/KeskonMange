import 'package:client/data/repositories/book_repository.dart';
import 'package:client/http/books/add_recipe_to_book_request.dart';
import 'package:client/http/books/create_new_book_request.dart';
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

  @override
  Future<int> deleteRecipeFromBook(int bookId, int recipeId) {
    // TODO: implement deleteRecipeFromBook
    throw UnimplementedError();
  }
}
