import 'package:client/model/recipe/preview.dart';
import 'package:flutter/material.dart';

import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';

class ComingRecipesViewModel extends ChangeNotifier {
  WidgetStates _state = WidgetStates.idle;
  List<RecipePreview> _recipes = [];

  WidgetStates get state => _state;
  List<RecipePreview> get recipes => _recipes;

  ComingRecipesViewModel() {
    getRecipes();
    notifyListeners();
  }

  Future<void> getRecipes() async {
    //recipes = await RepositoriesManager().getCalendarRepository().getNextPlannedRecipes(3);
    var ids = [1, 2, 3];
    List<RecipePreview> recipes = [];
    for (var id = 0; id < ids.length; id++) {
      RecipePreview? recipe = await GetRecipeFromIdUseCase(
              RepositoriesManager().getRecipeRepository(), ids[id])
          .execute();
      ;
      if (recipe != null) recipes.add(recipe);
    }
    _recipes = recipes;
    _state = WidgetStates.ready;
    notifyListeners();
  }
}
