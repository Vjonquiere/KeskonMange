import 'dart:ui';

import 'package:client/model/recipe/preview.dart';

abstract class RecipeRepository {
  Future<int> createNewRecipe(RecipePreview recipe);
  Future<List<RecipePreview>> getLastRecipes(int count);
  Future<List<int>> getLastRecipesIds(int count);
  Future<RecipePreview?> getRecipeFromId(int recipeId);
  Future<Image> getRecipeImage(int recipeId, String format);
}
