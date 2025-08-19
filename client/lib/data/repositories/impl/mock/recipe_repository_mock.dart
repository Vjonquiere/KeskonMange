import 'dart:ui';
import 'package:client/data/repositories/recipe_repository.dart';
import '../../../../model/recipe/preview.dart';

class RecipeRepositoryMock extends RecipeRepository {
  List<RecipePreview> recipes = [];
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
    List<RecipePreview> last = [];
    for (int i = 1; i <= count; i++) {
      last.add(recipes[recipes.length - i]);
    }
    return last;
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) async {
    for (RecipePreview recipe in recipes) {
      if (recipe.id == recipeId) return recipe;
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
    List<int> last = [];
    for (int i = 1; i <= count; i++) {
      last.add(recipes[recipes.length - i].id);
    }
    return last;
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName) async {
    List<RecipePreview> matching = [];
    for (RecipePreview recipe in recipes) {
      if (recipe.title.toLowerCase().startsWith(recipeName.toLowerCase()))
        matching.add(recipe);
    }
    return matching;
  }
}
