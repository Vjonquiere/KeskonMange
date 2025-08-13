import 'package:client/core/ViewModel.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';
import '../../../model/recipe/preview.dart';

class TodayMealViewModel extends ViewModel {
  int _currentRecipeIndex = 0;
  List<RecipePreview> _recipes = [];

  int get radioButtonCount => _recipes.length;
  int get currentRadioButton => _currentRecipeIndex;
  RecipePreview get currentRecipe => _recipes[_currentRecipeIndex];

  TodayMealViewModel() {
    _getRecipes([1, 2, 3]);
    notifyListeners();
  }

  Future<RecipePreview?> _getRecipe(int id) async {
    return GetRecipeFromIdUseCase(
            RepositoriesManager().getRecipeRepository(), id)
        .execute();
  }

  void _getRecipes(List<int> ids) async {
    List<RecipePreview> recipes = [];
    for (var id = 0; id < ids.length; id++) {
      RecipePreview? recipe = await _getRecipe(ids[id]);
      if (recipe != null) recipes.add(recipe);
    }
    _recipes = recipes;
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
