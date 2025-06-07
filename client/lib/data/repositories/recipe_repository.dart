import 'dart:ui';

import 'package:client/model/recipe.dart';

abstract class RecipeRepository {
  Future<int> createNewRecipe(
      Recipe recipe, RecipeRestrictions restrictions, RecipeTime time);
  Future<List<Recipe>> getLastRecipes(int count);
  Future<Recipe> getRecipeFromId(int recipeId);
  Future<Image> getRecipeImage(int recipeId, String format);
}
