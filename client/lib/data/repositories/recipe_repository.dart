import 'dart:ui';

import 'package:client/model/recipe/preview.dart';

import '../../model/recipe/recipe.dart';

abstract class RecipeRepository {
  Future<int> createNewRecipe(Recipe recipe);
  Future<List<RecipePreview>> getLastRecipes(int count);
  Future<List<int>> getLastRecipesIds(int count);
  Future<RecipePreview?> getRecipeFromId(int recipeId);
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName,
      {int? count});
  Future<Image> getRecipeImage(int recipeId, String format);
  Future<Recipe?> getCompleteRecipe(int recipeId);
}
