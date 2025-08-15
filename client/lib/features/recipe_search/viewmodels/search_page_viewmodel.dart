import 'package:client/core/ViewModel.dart';
import 'package:client/core/widget_states.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';
import '../../../data/usecases/recipes/get_last_recipes_ids_use_case.dart';
import '../../../model/recipe/preview.dart';

class SearchPageViewModel extends ViewModel {
  List<RecipePreview> recipes = [];

  int get recipesCount => recipes.length;
  RecipePreview getRecipe(int index) => recipes[index];

  SearchPageViewModel() {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setStateValue(WidgetStates.idle);
    List<int> recipeIds = await GetLastRecipesUseCase(
            RepositoriesManager().getRecipeRepository(), 30)
        .execute();
    debugPrint(recipeIds.toString());
    for (int id in recipeIds) {
      RecipePreview? recipe = await GetRecipeFromIdUseCase(
              RepositoriesManager().getRecipeRepository(), id)
          .execute();
      if (recipe != null) recipes.add(recipe);
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }
}
