import 'package:client/http/HttpRequest.dart';

class GetRecipeImageRequest extends HttpRequest {
  final int _recipeId;
  final String _format;

  GetRecipeImageRequest(this._recipeId, this._format);

  @override
  Future<int> send() {
    return super.process(
      RequestMode.get,
      "/recipe/image",
      queryParameters: <String, String>{
        "recipeId": _recipeId.toString(),
        "format": _format
      },
      authNeeded: true,
    );
  }
}
