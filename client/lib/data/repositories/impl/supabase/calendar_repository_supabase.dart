import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';

class CalendarRepositorySupabase extends CalendarRepository {
  @override
  Future<bool> addNewRecipeToCalendar(DateTime date, int recipeId) {
    // TODO: implement addNewRecipeToCalendar
    throw UnimplementedError();
  }

  @override
  Future<Month> getCompleteMonth(int monthCount) {
    // TODO: implement getCompleteMonth
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getDateFromPlannedRecipe(int recipeId) {
    // TODO: implement getDateFromPlannedRecipe
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getNextPlannedRecipes(int count) {
    // TODO: implement getNextPlannedRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getTodayCommunityRecipes() {
    // TODO: implement getTodayCommunityRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<RecipePreview>> getTodayUserRecipes() {
    // TODO: implement getTodayUserRecipes
    throw UnimplementedError();
  }

  @override
  Future<bool> removePlannedRecipeFromCalendar(DateTime date, int recipeId) {
    // TODO: implement removePlannedRecipeFromCalendar
    throw UnimplementedError();
  }

  @override
  Future<bool> updatePlannedRecipe(
      DateTime originalDate, DateTime newDate, int recipeId) {
    // TODO: implement updatePlannedRecipe
    throw UnimplementedError();
  }
}
