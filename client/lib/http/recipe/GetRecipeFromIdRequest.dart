import 'dart:convert';

import 'package:client/http/HttpRequest.dart';
import 'package:client/model/recipe.dart';

class GetRecipeRequest extends HttpRequest {
  final String _id;
  GetRecipeRequest(this._id);

  Recipe? getRecipe() {
    return Recipe.fromJson(jsonDecode(super.getBody()));
  }

  @override
  Future<int> send() async {
    return (await super.process(RequestMode.get, 'recipe/$_id', authNeeded: true));
  }
}
