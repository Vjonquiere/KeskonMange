import 'dart:ui';
import 'package:client/data/repositories/recipe_repository.dart';
import '../../../../model/recipe/preview.dart';

class RecipeRepositoryMock extends RecipeRepository {
  List<RecipePreview> recipes = <RecipePreview>[];
  int nextId = 0;

  @override
  Future<int> createNewRecipe(RecipePreview recipe) async {
    recipe.id = nextId;
    recipes.add(recipe);
    nextId++;
    return 200;
  }

  @override
  Future<List<RecipePreview>> getLastRecipes(int count) async {
    final List<RecipePreview> last = <RecipePreview>[];
    for (int i = 1; i <= count; i++) {
      last.add(recipes[recipes.length - i]);
    }
    return last;
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) async {
    for (RecipePreview recipe in recipes) {
      if (recipe.id == recipeId) {
        return recipe;
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
      last.add(recipes[recipes.length - i].id);
    }
    return last;
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName) async {
    final List<RecipePreview> matching = <RecipePreview>[];
    for (RecipePreview recipe in recipes) {
      if (recipe.title.toLowerCase().contains(recipeName.toLowerCase())) {
        matching.add(recipe);
      }
    }
    return matching;
  }
}
