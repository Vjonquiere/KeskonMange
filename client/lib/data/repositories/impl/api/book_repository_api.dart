import 'package:client/data/repositories/book_repository.dart';
import 'package:client/http/books/AddRecipeToBookRequest.dart';
import 'package:client/http/books/CreateNewBookRequest.dart';

class BookRepositoryApi extends BookRepository {
  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) async {
    return (await AddRecipeToBookRequest(recipeId, bookId).send());
  }

  @override
  Future<int> createNewBook(String name) async {
    return (await CreateNewBookRequest(name).send());
  }
}
