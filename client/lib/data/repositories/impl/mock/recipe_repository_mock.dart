import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/features/recipe_search/model/ingredient_filter.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:client/model/recipe/recipe.dart';
import '../../../../model/recipe/preview.dart';

class RecipeRepositoryMock extends RecipeRepository {
  List<Recipe> recipes = <Recipe>[];
  int _nextId = 0;

  @override
  Future<int> createNewRecipe(Recipe recipe) async {
    recipe.recipePreview.id = _nextId;
    recipes.add(recipe);
    _nextId++;
    return 200;
  }

  @override
  Future<List<RecipePreview>> getLastRecipes(int count) async {
    final List<RecipePreview> last = <RecipePreview>[];
    for (int i = 1; i <= count; i++) {
      last.add(recipes[recipes.length - i].recipePreview);
    }
    return last;
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) async {
    for (Recipe recipe in recipes) {
      if (recipe.recipePreview.id == recipeId) {
        return recipe.recipePreview;
      }
    }
    return null;
  }

  @override
  Future<Image> getRecipeImage(int recipeId, String format) {
    // TODO: implement getRecipeImage
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getLastRecipesIds(int count) async {
    final List<int> last = <int>[];
    for (int i = 1; i <= count; i++) {
      last.add(recipes[recipes.length - i].recipePreview.id);
    }
    return last;
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName,
      {int? count}) async {
    final List<RecipePreview> matching = <RecipePreview>[];
    for (Recipe recipe in recipes) {
      if (recipe.recipePreview.title
          .toLowerCase()
          .contains(recipeName.toLowerCase())) {
        matching.add(recipe.recipePreview);
      }
    }
    if (count != null) {
      return matching.sublist(0, min(count, matching.length));
    }
    return matching;
  }

  @override
  Future<Recipe?> getCompleteRecipe(int recipeId) async {
    for (Recipe recipe in recipes) {
      if (recipe.recipePreview.id == recipeId) {
        return recipe;
      }
    }
    return null;
  }

  // TODO: Code factorisation
  Future<List<Recipe>> _getCompleteRecipeMatchingName(String recipeName,
      {int? count}) async {
    final List<Recipe> matching = <Recipe>[];
    for (Recipe recipe in recipes) {
      if (recipe.recipePreview.title
          .toLowerCase()
          .contains(recipeName.toLowerCase())) {
        matching.add(recipe);
      }
    }
    if (count != null) {
      return matching.sublist(0, min(count, matching.length));
    }
    return matching;
  }

  @override
  Future<List<RecipePreview>> advancedResearch(
      {String? name, List<Filter>? filters}) async {
    final List<Recipe> matchingNameRecipes =
        await _getCompleteRecipeMatchingName(name ?? "");
    final List<Recipe> matchingRecipes = [];
    if (filters != null) {
      for (Filter filter in filters) {
        if (filter is IngredientFilter) {
          for (Recipe recipe in matchingNameRecipes) {
            final List<int> recipeIngredients =
                recipe.ingredients.map((e) => e.ingredientId).toList();
            bool toAdd = true;
            for (Ingredient ingredient in filter.ingredients) {
              if (!recipeIngredients.contains(ingredient.id)) {
                toAdd = false;
              }
            }
            if (toAdd) matchingRecipes.add(recipe);
          }
        }
      }
    }
    return matchingRecipes.map((Recipe e) => e.recipePreview).toList();
  }
}
