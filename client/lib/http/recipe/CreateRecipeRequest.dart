import 'package:client/http/HttpRequest.dart';

import '../../model/recipe/preview.dart';

class CreateRecipeRequest extends HttpRequest {
  final RecipePreview _recipe;

  CreateRecipeRequest(this._recipe);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.post,
      'recipe/add',
      body: <String, Object>{
        'title': _recipe.title,
        'type': _recipe.type,
        'difficulty': _recipe.difficulty,
        'cost': _recipe.cost,
        'vegetarian': _recipe.vegetarian,
        'vegan': _recipe.vegan,
        'hasGluten': _recipe.hasGluten,
        'hasLactose': _recipe.hasLactose,
        'hasPork': _recipe.hasPork,
        'salty': _recipe.salty,
        'sweet': _recipe.sweet,
        'preparation': _recipe.preparationTime,
        'rest': _recipe.restTime,
        'cook': _recipe.cookTime,
        'owner': _recipe.owner,
        'public': _recipe.public,
      },
      authNeeded: true,
    ));
  }
}
