import 'dart:collection';
import 'dart:ffi';
import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/model/recipe.dart';

class RecipeRepositoryMock extends RecipeRepository {
  List<Recipe> recipes = [];
  Map<int, RecipeRestrictions> restrictionsMap = HashMap();
  Map<int, RecipeTime> timeMap = HashMap();
  int nextId = 0;

  @override
  Future<int> createNewRecipe(
      Recipe recipe, RecipeRestrictions restrictions, RecipeTime time) async {
    recipe.id = nextId;
    recipes.add(recipe);
    restrictionsMap[nextId] = restrictions;
    timeMap[nextId] = time;
    nextId++;
    return 200;
  }

  @override
  Future<List<Recipe>> getLastRecipes(int count) async {
    List<Recipe> last = [];
    for (int i = 1; i <= count; i++) {
      last.add(recipes[recipes.length - i]);
    }
    return last;
  }

  @override
  Future<Recipe> getRecipeFromId(int recipeId) async {
    for (Recipe recipe in recipes) {
      if (recipe.id == recipeId) return recipe;
    }
    return Recipe(-1, "title", "type", -1, -1, -1, -1, -1);
  }

  @override
  Future<Image> getRecipeImage(int recipeId, String format) {
    // TODO: implement getRecipeImage
    throw UnimplementedError();
  }
}
