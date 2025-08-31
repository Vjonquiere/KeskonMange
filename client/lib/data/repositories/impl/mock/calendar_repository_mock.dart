import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';

class CalendarRepositoryMock extends CalendarRepository {
  @override
  Future<Month> getCompleteMonth(int monthCount) async {
    DateTime current = DateTime.timestamp();
    current = current.add(Duration(days: 30 * monthCount));
    return Month(current.year, current.month, <PlannedRecipe>[
      PlannedRecipe("${current.day}-${current.month}-${current.year}", 1, 1, ""),
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
    return <RecipePreview>[];
  }
}
