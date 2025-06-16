import 'dart:convert';

import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/http/calendar/CompleteMonthRequest.dart';
import 'package:client/http/calendar/NextPlannedRecipesRequest.dart';
import 'package:client/model/month.dart';
import 'package:client/model/recipe/preview.dart';

class CalendarRepositoryApi extends CalendarRepository {
  @override
  Future<Month> getCompleteMonth(int monthCount) async {
    CompleteMonthRequest req = CompleteMonthRequest(monthCount);
    if ((await req.send()) != 200) return Month(1970, 1, [], []);
    return Month.fromJson(jsonDecode(req.getBody()));
  }

  @override
  Future<List<RecipePreview>> getNextPlannedRecipes(int count) async {
    NextPlannedRecipesRequest req = NextPlannedRecipesRequest(count);
    await req.send();
    return []; // TODO: Change it with list of recipe
  }
}
