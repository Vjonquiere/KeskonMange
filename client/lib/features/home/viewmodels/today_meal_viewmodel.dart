import 'package:client/core/view_model.dart';

import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';
import '../../../model/recipe/preview.dart';

class TodayMealViewModel extends ViewModel {
  int _currentRecipeIndex = 0;
  List<RecipePreview> _recipes = <RecipePreview>[];
  bool _noPlannedRecipes = false;

  int get radioButtonCount => _recipes.length;
  int get currentRadioButton => _currentRecipeIndex;
  RecipePreview get currentRecipe => _recipes[_currentRecipeIndex];
  bool get noPlannedRecipes => _noPlannedRecipes;

  TodayMealViewModel() {
    _getRecipes();
    notifyListeners();
  }

  void _getRecipes() async {
    _recipes = await RepositoriesManager()
        .getCalendarRepository()
        .getTodayUserRecipes();
    if (_recipes.isEmpty) {
      _noPlannedRecipes = true;
      _recipes = await RepositoriesManager()
          .getCalendarRepository()
          .getTodayCommunityRecipes();
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  void nextRecipe() {
    _currentRecipeIndex = (_currentRecipeIndex + 1) % _recipes.length;
    notifyListeners();
  }

  void previousRecipe() {
    _currentRecipeIndex =
        (_currentRecipeIndex - 1 + _recipes.length) % _recipes.length;
    notifyListeners();
  }

  void onRecipeChanged(int? index) {
    if (index != null) {
      _currentRecipeIndex = index;
    }
    notifyListeners();
  }
}
