import 'dart:math';

import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient_quantity.dart';
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

  DateTime addMonths(DateTime date, int monthsToAdd) {
    final int year = date.year + ((date.month - 1 + monthsToAdd) ~/ 12);
    final int month = (date.month - 1 + monthsToAdd) % 12 + 1;
    int day = date.day;

    final int lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfTargetMonth) {
      day = lastDayOfTargetMonth;
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  @override
  Future<Month> getCompleteMonth(int monthCount, {int weekStart = 1}) async {
    final DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    firstDayOfMonth = addMonths(firstDayOfMonth, monthCount);
    DateTime currentDay =
        DateTime(firstDayOfMonth.year, firstDayOfMonth.month, 1);

    final List<List<int>> monthTemplate = <List<int>>[];
    List<int> currentWeek = <int>[];

    final int leadingEmpty = (currentDay.weekday - weekStart + 7) % 7;
    for (int i = 0; i < leadingEmpty; i++) {
      currentWeek.add(0);
    }

    while (currentDay.month == firstDayOfMonth.month) {
      currentWeek.add(currentDay.day);
      if (currentWeek.length == 7) {
        monthTemplate.add(currentWeek);
        currentWeek = [];
      }
      currentDay = currentDay.add(const Duration(days: 1));
    }

    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(0);
      }
      monthTemplate.add(currentWeek);
    }
    return Month(firstDayOfMonth.year, firstDayOfMonth.month, <PlannedRecipe>[],
        monthTemplate);
  }

  @override
  Future<List<DateTime>> getDateFromPlannedRecipe(int recipeId) async {
    final PostgrestList res = await Supabase.instance.client.rest
        .from("calendar")
        .select("date")
        .eq("recipe_id", recipeId);
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

  @override
  Future<List<IngredientQuantity>> getNeededIngredientsForDateRange(
      {DateTime? from, DateTime? to}) {
    // TODO: implement getNeededIngredientsForDateRange
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getPlannedRecipesForDateRange(
      {DateTime? from, DateTime? to}) {
    // TODO: implement getPlannedRecipesForDateRange
    throw UnimplementedError();
  }
}
