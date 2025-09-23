import 'dart:convert';

import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/http/calendar/complete_month_request.dart';
import 'package:client/http/calendar/next_planned_recipes_request.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';

class CalendarRepositoryApi extends CalendarRepository {
  @override
  Future<Month> getCompleteMonth(int monthCount) async {
    final CompleteMonthRequest req = CompleteMonthRequest(monthCount);
    if ((await req.send()) != 200) {
      return Month(1970, 1, <PlannedRecipe>[], <List<int>>[]);
    }
    return Month.fromJson(jsonDecode(req.getBody()));
  }

  @override
  Future<List<RecipePreview>> getNextPlannedRecipes(int count) async {
    final NextPlannedRecipesRequest req = NextPlannedRecipesRequest(count);
    await req.send();
    return <RecipePreview>[]; // TODO: Change it with list of recipe
  }

  @override
  Future<bool> addNewRecipeToCalendar(DateTime date, int recipeId) {
    // TODO: implement addNewRecipeToCalendar
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getDateFromPlannedRecipe(int recipeId) {
    // TODO: implement getDateFromPlannedRecipe
    throw UnimplementedError();
  }
}
