import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';

abstract class CalendarRepository {
  Future<Month> getCompleteMonth(
    int monthCount,
  ); // monthCount is the number of month to remove (0 for current)
  Future<List<RecipePreview>> getNextPlannedRecipes(int count);
  Future<bool> addNewRecipeToCalendar(DateTime date, int recipeId);
  Future<List<DateTime>> getDateFromPlannedRecipe(int recipeId);
  Future<bool> removePlannedRecipeFromCalendar(DateTime date, int recipeId);
  Future<bool> updatePlannedRecipe(
      DateTime originalDate, DateTime newDate, int recipeId);
  Future<List<RecipePreview>> getTodayUserRecipes();
  Future<List<RecipePreview>> getTodayCommunityRecipes();
}
