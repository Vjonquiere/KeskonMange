import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/http/recipe/GetLastRecipesRequest.dart';
import 'package:client/http/recipe/GetRecipeFromIdRequest.dart';
import 'package:client/model/recipe/preview.dart';

class RecipeRepositoryApi extends RecipeRepository {
  @override
  Future<int> createNewRecipe(RecipePreview recipe) async {
    //TODO: Change to work with new Recipe object
    // return (await CreateRecipeRequest(recipe).send());
    return 200;
  }

  @override
  Future<List<RecipePreview>> getLastRecipes(int count) async {
    final GetLastRecipesRequest req = GetLastRecipesRequest();
    if ((await req.send()) != 200) return <RecipePreview>[];
    return <RecipePreview>[
      RecipePreview.fromJson(req.getJsonBody()),
    ]; // TODO: Change because it returns ids and not Recipes objects
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) async {
    final GetRecipeRequest req = GetRecipeRequest(recipeId.toString());
    if ((await req.send()) != 200) null;
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
    if ((await req.send()) != 200) return <int>[];
    return req.ids();
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName) {
    // TODO: implement getRecipeMatchingName
    throw UnimplementedError();
  }
}
