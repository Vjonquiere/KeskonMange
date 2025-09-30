import 'dart:math';

import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/features/recipe_search/model/meal_course_filter.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../model/recipe/recipe.dart';

class CalendarRepositoryMock extends CalendarRepository {
  Database? _database;

  CalendarRepositoryMock() {
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'calendar.db'),
            onCreate: (Database db, int version) {
      return db
          .execute('CREATE TABLE calendar(date INTEGER, recipe_id INTEGER)');
    }, version: 1);
  }

  @override
  Future<Month> getCompleteMonth(int monthCount) async {
    DateTime current = DateTime.timestamp();
    current = current.add(Duration(days: 30 * monthCount));
    return Month(current.year, current.month, <PlannedRecipe>[
      PlannedRecipe(
          "${current.day}-${current.month}-${current.year}", 1, 1, ""),
    ], <List<int>>[
      <int>[0, 0, 0, 1, 2, 3, 4],
      <int>[5, 6, 7, 8, 9, 10, 11],
      <int>[12, 13, 14, 15, 16, 17, 18],
      <int>[19, 20, 21, 22, 23, 24, 25],
      <int>[26, 27, 28, 29, 30, 31, 0],
    ]);
  }

  @override
  Future<List<RecipePreview>> getNextPlannedRecipes(int count) async {
    if (_database == null) return [];
    final List<Map<String, Object?>>? planned = await _database?.query(
        "calendar",
        orderBy: "date ASC",
        where: "date >= ?",
        whereArgs: [DateTime.now().millisecondsSinceEpoch]);
    if (planned == null || planned.isEmpty) return [];
    final recipes = [
      for (final {'date': int date as int, 'recipe_id': int recipe_id as int}
          in planned)
        await RepositoriesManager()
            .getRecipeRepository()
            .getRecipeFromId(recipe_id)
    ].whereType<RecipePreview>().toList();
    return recipes.sublist(0, min(count, recipes.length));
  }

  @override
  Future<bool> addNewRecipeToCalendar(DateTime date, int recipeId) async {
    if (_database == null) return false;
    await _database?.insert("calendar",
        {"date": date.millisecondsSinceEpoch, "recipe_id": recipeId});
    return true;
  }

  @override
  Future<List<DateTime>> getDateFromPlannedRecipe(int recipeId) async {
    if (_database == null) return [];
    final List<Map<String, Object?>>? planned = await _database
        ?.query("calendar", where: "recipe_id=$recipeId", orderBy: "date ASC");
    if (planned == null || planned.isEmpty) return [];
    return [
      for (final {'date': int date as int, 'recipe_id': recipe_id as int}
          in planned)
        DateTime.fromMillisecondsSinceEpoch(date),
    ];
  }

  @override
  Future<bool> removePlannedRecipeFromCalendar(
      DateTime date, int recipeId) async {
    if (_database == null) return false;
    final int? res = await _database?.delete("calendar",
        where: "recipe_id=? AND date=?",
        whereArgs: [recipeId, date.millisecondsSinceEpoch]);
    return (res == null || res == 0) ? false : true;
  }

  @override
  Future<bool> updatePlannedRecipe(
      DateTime originalDate, DateTime newDate, int recipeId) async {
    if (_database == null) return false;
    final int? res = await _database?.update(
      "calendar",
      {"date": newDate.millisecondsSinceEpoch, "recipe_id": recipeId},
      where: "recipe_id=? AND date=?",
      whereArgs: [recipeId, originalDate.millisecondsSinceEpoch],
    );
    return (res == null || res == 0) ? false : true;
  }

  @override
  Future<List<RecipePreview>> getTodayUserRecipes() async {
    final DateTime now = DateTime.now();
    return await getPlannedRecipesForDateRange(
        from: now.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0),
        to: now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 0));
  }

  @override
  Future<List<RecipePreview>> getTodayCommunityRecipes() async {
    final List<RecipePreview> selectedRecipes = <RecipePreview>[];
    for (MealCourse course in MealCourse.values) {
      debugPrint(course.name);
      final List<RecipePreview> recipes = await RepositoriesManager()
          .getRecipeRepository()
          .advancedResearch(filters: <Filter>[
        MealCourseFilter({course})
      ]);
      selectedRecipes.add(recipes.elementAt(Random().nextInt(recipes.length)));
    }
    return selectedRecipes;
  }

  @override
  Future<List<IngredientQuantity>> getNeededIngredientsForDateRange(
      {DateTime? from, DateTime? to}) async {
    final List<IngredientQuantity> neededIngredients = [];
    final List<RecipePreview> plannedRecipes =
        await getPlannedRecipesForDateRange(from: from, to: to);
    for (RecipePreview recipe in plannedRecipes) {
      final Recipe? completeRecipe = await RepositoriesManager()
          .getRecipeRepository()
          .getCompleteRecipe(recipe.id);
      if (completeRecipe != null) {
        neededIngredients.addAll(completeRecipe.ingredients);
      }
    }
    return neededIngredients;
  }

  @override
  Future<List<RecipePreview>> getPlannedRecipesForDateRange(
      {DateTime? from, DateTime? to}) async {
    if (_database == null) return [];
    final List<Map<String, Object?>>? planned = await _database
        ?.query("calendar", where: "date<=? AND date>=?", whereArgs: [
      to != null
          ? to.millisecondsSinceEpoch
          : DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      from != null
          ? from.millisecondsSinceEpoch
          : DateTime.now().millisecondsSinceEpoch
    ]);
    if (planned == null || planned.isEmpty) return [];
    return <RecipePreview?>[
      for (final {'date': int date as int, 'recipe_id': recipe_id as int}
          in planned)
        await RepositoriesManager()
            .getRecipeRepository()
            .getRecipeFromId(recipe_id)
    ].whereType<RecipePreview>().toList();
  }
}
