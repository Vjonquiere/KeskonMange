import 'dart:math';

import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final List<Map<String, Object?>>? planned =
        await _database?.query("calendar", orderBy: "date ASC");
    if (planned == null || planned.isEmpty) return [];
    final recipes = [
      for (final {'date': int date as int, 'recipe_id': int recipe_id as int}
          in planned)
        await RepositoriesManager()
            .getRecipeRepository()
            .getRecipeFromId(recipe_id)
      //DateTime.fromMillisecondsSinceEpoch(date),
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
    final List<Map<String, Object?>>? planned =
        await _database?.query("calendar", where: "recipe_id=$recipeId");
    if (planned == null || planned.isEmpty) return [];
    return [
      for (final {'date': int date as int, 'recipe_id': recipe_id as int}
          in planned)
        DateTime.fromMillisecondsSinceEpoch(date),
    ];
  }
}
