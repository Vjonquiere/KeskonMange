import 'dart:math';
import 'dart:ui';

import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/recipe.dart';
import 'package:client/model/recipe/step.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../features/recipe_planning/models/days.dart';
import '../../../../features/recipe_search/model/cooking_time_filter.dart';
import '../../../../features/recipe_search/model/ingredient_filter.dart';
import '../../../../features/recipe_search/model/meal_course_filter.dart';
import '../../../../features/recipe_search/model/preparation_time_filter.dart';
import '../../../../model/ingredient_quantity.dart';

class RecipeRepositorySupabase extends RecipeRepository {
  @override
  Future<List<RecipePreview>> advancedResearch(
      {String? name, List<Filter>? filters}) async {
    List<int>? ingredientIds;
    int? maxPrepTime;
    int? maxCookTime;
    List<String>? mealCourses;

    for (final filter in filters ?? []) {
      if (filter is IngredientFilter) {
        ingredientIds = filter.ingredients.map((e) => e.id).toList();
      } else if (filter is PreparationTimeFilter) {
        maxPrepTime = filter.time;
      } else if (filter is CookingTimeFilter) {
        maxCookTime = filter.time;
      } else if (filter is MealCourseFilter) {
        mealCourses = filter.courses.map((mc) {
          return switch (mc) {
            MealCourse.starter => "starter",
            MealCourse.main => "main",
            MealCourse.dessert => "dessert",
          };
        }).toList();
      }
    }

    final response =
        await Supabase.instance.client.rpc('advanced_research', params: {
      'name': name,
      'ingredient_ids': ingredientIds,
      'max_preparation_time': maxPrepTime,
      'max_cooking_time': maxCookTime,
      'meal_courses': mealCourses,
    });

    return (response as List)
        .map((e) => RecipePreview.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> createNewRecipe(Recipe recipe) async {
    PostgrestList res =
        await Supabase.instance.client.rest.from("recipes").insert({
      "title": recipe.recipePreview.title,
      "image": "",
      "type": recipe.recipePreview.type,
      "cost": recipe.recipePreview.cost,
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
      "public": 1,
      "portions": recipe.portions
    }).select();
    if (res.isEmpty) return 404;
    final int id = res.first["id"];
    for (IngredientQuantity ingredient in recipe.ingredients) {
      await Supabase.instance.client.rest.from("ingredient_quantity").insert({
        "recipe_id": id,
        "ingredient_id": ingredient.ingredientId,
        "quantity": ingredient.quantity,
        "unit": ingredient.unit.unit.toString().split(".").last
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
  Future<Recipe?> getCompleteRecipe(int recipeId) async {
    final Map<String, dynamic> recipe = {};
    PostgrestList preview = await Supabase.instance.client.rest
        .from("recipes")
        .select(
            "id, title, image, type, cost, difficulty, vegetarian, vegan, has_gluten, has_lactose, has_pork, salty, sweet, preparation_time, rest_time, cook_time, owner, public")
        .eq("id", recipeId);
    if (preview.isEmpty) return null;
    recipe["recipePreview"] = preview.first;
    PostgrestList ingredients = await Supabase.instance.client.rest
        .from("ingredient_quantity")
        .select("ingredient_id, quantity, unit")
        .eq("recipe_id", recipeId);
    recipe["ingredients"] = ingredients;
    PostgrestList steps = await Supabase.instance.client.rest
        .from("recipe_steps")
        .select("title, step")
        .eq("recipe_id", recipeId)
        .order("index", ascending: true);
    recipe["steps"] = steps;
    recipe["portions"] = 1; // TODO: fetch portions
    return Recipe.fromJson(recipe);
  }

  @override
  Future<List<RecipePreview>> getLastRecipes(int count) async {
    PostgrestList preview = await Supabase.instance.client.rest
        .from("recipes")
        .select(
            "id, title, image, type, cost, difficulty, vegetarian, vegan, has_gluten, has_lactose, has_pork, salty, sweet, preparation_time, rest_time, cook_time, owner, public")
        .order("id")
        .limit(min(count, 50));
    return preview.map((e) => RecipePreview.fromJson(e)).toList();
  }

  @override
  Future<List<int>> getLastRecipesIds(int count) async {
    PostgrestList preview = await Supabase.instance.client.rest
        .from("recipes")
        .select("id")
        .order("id")
        .limit(10);
    return preview.map((e) => e["id"] as int).toList();
  }

  @override
  Future<RecipePreview?> getRecipeFromId(int recipeId) async {
    PostgrestList preview = await Supabase.instance.client.rest
        .from("recipes")
        .select(
            "id, title, image, type, cost, difficulty, vegetarian, vegan, has_gluten, has_lactose, has_pork, salty, sweet, preparation_time, rest_time, cook_time, owner, public")
        .eq("id", recipeId);
    if (preview.isEmpty) return null;
    return RecipePreview.fromJson(preview.first);
  }

  @override
  Future<Image> getRecipeImage(int recipeId, String format) {
    // TODO: implement getRecipeImage
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getRecipeMatchingName(String recipeName,
      {int? count}) async {
    PostgrestList preview = await Supabase.instance.client.rest
        .from("recipes")
        .select(
            "id, title, image, type, cost, difficulty, vegetarian, vegan, has_gluten, has_lactose, has_pork, salty, sweet, preparation_time, rest_time, cook_time, owner, public")
        .like("title", "%$recipeName%")
        .limit(count ?? 10);
    return preview.map((e) => RecipePreview.fromJson(e)).toList();
  }
}
