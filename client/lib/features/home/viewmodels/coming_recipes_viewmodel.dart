import 'dart:collection';

import 'package:client/model/recipe/preview.dart';

import '../../../core/view_model.dart';
import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';

class ComingRecipesViewModel extends ViewModel {
  List<RecipePreview> _recipes = <RecipePreview>[];
  Map<RecipePreview, DateTime?> _calendarEntries = {};

  List<RecipePreview> get recipes => _recipes;
  Map<RecipePreview, DateTime?> get calendarEntries => _calendarEntries;

  ComingRecipesViewModel() {
    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await RepositoriesManager()
        .getCalendarRepository()
        .getNextPlannedRecipes(3);
    for (RecipePreview recipe in _recipes) {
      List<DateTime> entries = await RepositoriesManager()
          .getCalendarRepository()
          .getDateFromPlannedRecipe(recipe.id);
      if (entries.isEmpty) {
        _calendarEntries[recipe] = null;
      } else {
        _calendarEntries[recipe] = entries.first;
      }
    }

    /*final List<int> ids = <int>[1, 2, 3];
    final List<RecipePreview> recipes = <RecipePreview>[];
    for (int id = 0; id < ids.length; id++) {
      final RecipePreview? recipe = await GetRecipeFromIdUseCase(
        RepositoriesManager().getRecipeRepository(),
        ids[id],
      ).execute();
      if (recipe != null) {
        recipes.add(recipe);
      }
    }
    _recipes = recipes;*/
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }
}
