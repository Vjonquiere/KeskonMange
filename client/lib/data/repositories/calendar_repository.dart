import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';

abstract class CalendarRepository {
  Future<Month> getCompleteMonth(
    int monthCount,
  ); // monthCount is the number of month to remove (0 for current)
  Future<List<RecipePreview>> getNextPlannedRecipes(int count);
}
