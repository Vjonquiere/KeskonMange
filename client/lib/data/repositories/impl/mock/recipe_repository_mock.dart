import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/features/recipe_search/model/cooking_time_filter.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/features/recipe_search/model/ingredient_filter.dart';
import 'package:client/features/recipe_search/model/preparation_time_filter.dart';
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
    final List<Recipe> matchingRecipes =
        await _getCompleteRecipeMatchingName(name ?? "");
    if (filters != null) {
      for (Filter filter in filters) {
        if (filter is IngredientFilter) {
          matchingRecipes.removeWhere((Recipe recipe) {
            final List<int> recipeIngredientIds = recipe.ingredients
                .map((IngredientQuantity e) => e.ingredientId)
                .toList();
            bool recipeHasAllFilterIngredients = true;
            for (Ingredient filterIngredient in filter.ingredients) {
              if (!recipeIngredientIds.contains(filterIngredient.id)) {
                recipeHasAllFilterIngredients = false;
                break;
              }
            }
            return !recipeHasAllFilterIngredients;
          });
        }
        if (filter is PreparationTimeFilter) {
          matchingRecipes.removeWhere((Recipe recipe) {
            return recipe.recipePreview.preparationTime >
                filter.time;
          });
        }
        if (filter is CookingTimeFilter) {
          matchingRecipes.removeWhere((Recipe recipe) {
            return recipe.recipePreview.cookTime >
                filter.time;
          });
        }
      }
    }

    return matchingRecipes.map((Recipe e) => e.recipePreview).toSet().toList();
  }
}
