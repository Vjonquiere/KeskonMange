import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/recipe.dart';

class RecipeRepositorySupabase extends RecipeRepository {
  @override
  Future<List<RecipePreview>> advancedResearch(
      {String? name, List<Filter>? filters}) {
    // TODO: implement advancedResearch
    throw UnimplementedError();
  }

  @override
  Future<int> createNewRecipe(Recipe recipe) {
    // TODO: implement createNewRecipe
    throw UnimplementedError();
  }

  @override
  Future<Recipe?> getCompleteRecipe(int recipeId) {
    // TODO: implement getCompleteRecipe
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getLastRecipes(int count) {
    // TODO: implement getLastRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getLastRecipesIds(int count) {
    // TODO: implement getLastRecipesIds
    throw UnimplementedError();
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) {
    // TODO: implement getRecipeFromId
    throw UnimplementedError();
  }

  @override
  Future<Image> getRecipeImage(int recipeId, String format) {
    // TODO: implement getRecipeImage
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName,
      {int? count}) {
    // TODO: implement getRecipeMatchingName
    throw UnimplementedError();
  }
}
