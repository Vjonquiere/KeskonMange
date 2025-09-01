import 'dart:convert';

import 'package:client/http/http_request.dart';
import 'package:client/model/recipe/preview.dart';

class GetRecipeRequest extends HttpRequest {
  final String _id;
  GetRecipeRequest(this._id);

  RecipePreview? getRecipe() {
    return RecipePreview.fromJson(jsonDecode(super.getBody()));
  }

  @override
  Future<int> send() async {
    return (await super
        .process(RequestMode.get, 'recipe/$_id', authNeeded: true));
  }
}
