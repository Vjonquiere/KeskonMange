import 'package:client/http/HttpRequest.dart';
import 'package:client/model/recipe.dart';

class CreateRecipeRequest extends HttpRequest{
  final Recipe _recipe;
  final RecipeRestrictions _recipeRestrictions;
  final RecipeTime _recipeTime;

  CreateRecipeRequest(this._recipe, this._recipeRestrictions, this._recipeTime);

  @override
  Future<int> send() async {
    return (await super.process(
        RequestMode.post,
        'recipe/add',
        body: {
          'title': _recipe.title,
          'type': _recipe.type,
          'difficulty': _recipe.difficulty,
          'cost': _recipe.cost,
          'portions': _recipe.portions,
          'salty': _recipeRestrictions.salty,
          'sweet': _recipeRestrictions.sweet,
          'preparation_time': _recipeTime.preparation,
          'rest_time': _recipeTime.rest,
          'cook_time': _recipeTime.cook,
          'ingredients': [], //TODO: Add ingredients to body
    }));
  }

}