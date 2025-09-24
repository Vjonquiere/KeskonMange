import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/http/recipe/get_last_recipes_request.dart';
import 'package:client/http/recipe/get_recipe_from_id_request.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/recipe.dart';

class RecipeRepositoryApi extends RecipeRepository {
  @override
  Future<int> createNewRecipe(Recipe recipe) async {
    //TODO: Change to work with new Recipe object
    // return (await CreateRecipeRequest(recipe).send());
    return 200;
  }

  @override
  Future<List<RecipePreview>> getLastRecipes(int count) async {
    final GetLastRecipesRequest req = GetLastRecipesRequest();
    if ((await req.send()) != 200) {
      return <RecipePreview>[];
    }
    return <RecipePreview>[
      RecipePreview.fromJson(req.getJsonBody()),
    ]; // TODO: Change because it returns ids and not Recipes objects
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) async {
    final GetRecipeRequest req = GetRecipeRequest(recipeId.toString());
    if ((await req.send()) != 200) {
      null;
    }
    return RecipePreview.fromJson(req.getJsonBody());
  }

  @override
  Future<Image> getRecipeImage(int recipeId, String format) {
    // TODO: implement getRecipeImage
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getLastRecipesIds(int count) async {
    final GetLastRecipesRequest req = GetLastRecipesRequest();
    if ((await req.send()) != 200) {
      return <int>[];
    }
    return req.ids();
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName,
      {int? count}) {
    // TODO: implement getRecipeMatchingName
    throw UnimplementedError();
  }

  @override
  Future<Recipe?> getCompleteRecipe(int recipeId) {
    // TODO: implement getCompleteRecipe
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> advancedResearch(
      {String? name, List<Filter>? filters}) {
    // TODO: implement advancedResearch
    throw UnimplementedError();
  }
}
