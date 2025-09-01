import 'package:client/http/http_request.dart';

class AddRecipeToBookRequest extends HttpRequest {
  final int _recipeId;
  final int _bookId;
  AddRecipeToBookRequest(this._recipeId, this._bookId);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.post,
      'books/recipe/add',
      queryParameters: <String, String>{
        "bookId": _bookId.toString(),
        "recipeId": _recipeId.toString(),
      },
      authNeeded: true,
    ));
  }
}
