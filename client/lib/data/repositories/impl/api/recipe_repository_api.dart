import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/http/recipe/CreateRecipeRequest.dart';
import 'package:client/http/recipe/GetLastRecipesRequest.dart';
import 'package:client/http/recipe/GetRecipeFromIdRequest.dart';
import 'package:client/model/recipe.dart';

class RecipeRepositoryApi extends RecipeRepository {
  @override
  Future<int> createNewRecipe(
      Recipe recipe, RecipeRestrictions restrictions, RecipeTime time) async {
    return (await CreateRecipeRequest(recipe, restrictions, time).send());
  }

  @override
  Future<List<Recipe>> getLastRecipes(int count) async {
    GetLastRecipesRequest req = GetLastRecipesRequest();
    if ((await req.send()) != 200) return [];
    return [Recipe.fromJson(req.getJsonBody())];
  }

  @override
  Future<Recipe> getRecipeFromId(int recipeId) async {
    GetRecipeRequest req = GetRecipeRequest(recipeId.toString());
    if ((await req.send()) != 200)
      return Recipe(-1, "unknown", "unknown", -1, -1, -1, -1, -1);
    return Recipe.fromJson(req.getJsonBody());
  }

  @override
  Future<Image> getRecipeImage(int recipeId, String format) {
    // TODO: implement getRecipeImage
    throw UnimplementedError();
  }
}
