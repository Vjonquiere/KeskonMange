import 'package:client/model/month.dart';

import '../../model/recipe.dart';

abstract class CalendarRepository {
  Future<Month> getCompleteMonth(
      int monthCount); // monthCount is the number of month to remove (0 for current)
  Future<List<Recipe>> getNextPlannedRecipes(int count);
}
