import 'dart:math';

import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarRepositorySupabase extends CalendarRepository {
  @override
  Future<bool> addNewRecipeToCalendar(DateTime date, int recipeId) async {
    await Supabase.instance.client.rest.from("calendar").insert({
      'recipe_id': recipeId,
      'date': date.millisecondsSinceEpoch,
      'done': false
    });
    return true;
  }

  @override
  Future<Month> getCompleteMonth(int monthCount) {
    // TODO: implement getCompleteMonth
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getDateFromPlannedRecipe(int recipeId) async {
    final PostgrestList res = await Supabase.instance.client.rest
        .from("calendar")
        .select("date")
        .eq("recipeId", recipeId);
    return res
        .map((PostgrestMap e) => DateTime.fromMillisecondsSinceEpoch(e["date"]))
        .toList();
  }

  @override
  Future<List<RecipePreview>> getNextPlannedRecipes(int count) async {
    final PostgrestList res = await Supabase.instance.client.rest
        .from("calendar")
        .select("recipe_id")
        .gte("date", DateTime.now().millisecondsSinceEpoch)
        .limit(min(count, 50));
    final List<RecipePreview> recipes = [];
    for (PostgrestMap recipeId in res) {
      final RecipePreview? recipe = await RepositoriesManager()
          .getRecipeRepository()
          .getRecipeFromId(recipeId["recipe_id"]);
      if (recipe != null) recipes.add(recipe);
    }
    return recipes;
  }

  @override
  Future<List<RecipePreview>> getTodayCommunityRecipes() {
    // TODO: implement getTodayCommunityRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getTodayUserRecipes() async {
    final DateTime now = DateTime.now();
    final PostgrestList res = await Supabase.instance.client.rest
        .from("calendar")
        .select("recipe_id")
        .lte(
            "date",
            now
                .copyWith(hour: 23, minute: 59, second: 59, millisecond: 0)
                .millisecondsSinceEpoch)
        .gte(
            "date",
            now
                .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
                .millisecondsSinceEpoch);
    final List<RecipePreview> recipes = [];
    for (PostgrestMap recipeId in res) {
      final RecipePreview? recipe = await RepositoriesManager()
          .getRecipeRepository()
          .getRecipeFromId(recipeId["recipe_id"]);
      if (recipe != null) recipes.add(recipe);
    }
    return recipes;
  }

  @override
  Future<bool> removePlannedRecipeFromCalendar(
      DateTime date, int recipeId) async {
    await Supabase.instance.client.rest
        .from("calendar")
        .delete()
        .eq("date", date.millisecondsSinceEpoch)
        .eq("recipe_id", recipeId);
    return true;
  }

  @override
  Future<bool> updatePlannedRecipe(
      DateTime originalDate, DateTime newDate, int recipeId) async {
    await Supabase.instance.client.rest
        .from("calendar")
        .update({"date": newDate.millisecondsSinceEpoch})
        .eq("date", newDate.millisecondsSinceEpoch)
        .eq("recipe_id", recipeId);
    return true;
  }
}
