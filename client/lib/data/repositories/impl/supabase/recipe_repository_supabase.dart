import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/recipe.dart';
import 'package:client/model/recipe/step.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../model/ingredient_quantity.dart';

class RecipeRepositorySupabase extends RecipeRepository {
  @override
  Future<List<RecipePreview>> advancedResearch(
      {String? name, List<Filter>? filters}) {
    // TODO: implement advancedResearch
    throw UnimplementedError();
  }

  @override
  Future<int> createNewRecipe(Recipe recipe) async {
    PostgrestList res =
        await Supabase.instance.client.rest.from("recipes").insert({
      "title": recipe.recipePreview.title,
      "image": "",
      "type": recipe.recipePreview.type,
      "cost": recipe.recipePreview.cost.isOdd,
      "vegetarian": recipe.recipePreview.vegetarian,
      "vegan": recipe.recipePreview.vegan,
      "has_gluten": recipe.recipePreview.hasGluten,
      "has_lactose": recipe.recipePreview.hasLactose,
      "has_pork": recipe.recipePreview.hasPork,
      "salty": recipe.recipePreview.salty,
      "sweet": recipe.recipePreview.sweet,
      "preparation_time": recipe.recipePreview.preparationTime,
      "rest_time": recipe.recipePreview.restTime,
      "cook_time": recipe.recipePreview.cookTime,
      "public": true,
      "portions": recipe.portions
    }).select();
    if (res.isEmpty) return 404;
    final int id = res.first["id"];
    for (IngredientQuantity ingredient in recipe.ingredients) {
      await Supabase.instance.client.rest.from("ingredient_quantity").insert({
        "recipe_id": id,
        "ingredient_id": ingredient.ingredientId,
        "quantity": ingredient.quantity,
        "unit": ingredient.unit.unit.toString()
      });
    }
    for (Step step in recipe.steps) {
      await Supabase.instance.client.rest.from("recipe_steps").insert({
        "title": step.title,
        "recipe_id": id,
        "index": recipe.steps.indexOf(step),
        "step": step.stepText
      });
    }
    return 200;
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
