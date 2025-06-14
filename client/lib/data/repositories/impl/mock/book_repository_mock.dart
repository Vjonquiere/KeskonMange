import 'package:client/data/repositories/book_repository.dart';

class BookRepositoryMock extends BookRepository {
  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) async {
    return 200;
  }

  @override
  Future<int> createNewBook(String name) async {
    return 200;
  }
}
