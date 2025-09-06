import 'dart:collection';
import 'dart:ui';
import 'package:client/data/repositories/recipe_repository.dart';
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
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName) async {
    final List<RecipePreview> matching = <RecipePreview>[];
    for (Recipe recipe in recipes) {
      if (recipe.recipePreview.title
          .toLowerCase()
          .contains(recipeName.toLowerCase())) {
        matching.add(recipe.recipePreview);
      }
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
}
