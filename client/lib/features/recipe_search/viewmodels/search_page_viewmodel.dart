import 'dart:collection';

import 'package:client/core/view_model.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/features/recipe_search/model/filters.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';
import '../../../data/usecases/recipes/get_last_recipes_ids_use_case.dart';
import '../../../model/recipe/preview.dart';

class SearchPageViewModel extends ViewModel {
  List<RecipePreview> recipes = <RecipePreview>[];
  final Map<FilterType, Filter?> _filters = HashMap<FilterType, Filter>();
  String _searchText = "";

  int get recipesCount => recipes.length;
  RecipePreview getRecipe(int index) => recipes[index];

  SearchPageViewModel() {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setStateValue(WidgetStates.idle);
    final List<int> recipeIds = await GetLastRecipesUseCase(
      RepositoriesManager().getRecipeRepository(),
      30,
    ).execute();
    for (int id in recipeIds) {
      final RecipePreview? recipe = await GetRecipeFromIdUseCase(
        RepositoriesManager().getRecipeRepository(),
        id,
      ).execute();
      if (recipe != null) {
        recipes.add(recipe);
      }
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Future<void> _advancedSearch() async {
    setStateValue(WidgetStates.loading);
    notifyListeners();
    final List<int> recipeIds = await GetLastRecipesUseCase(
      RepositoriesManager().getRecipeRepository(),
      30,
    ).execute();
    for (int id in recipeIds) {
      final RecipePreview? recipe = await GetRecipeFromIdUseCase(
        RepositoriesManager().getRecipeRepository(),
        id,
      ).execute();
      if (recipe != null) {
        recipes.add(recipe);
      }
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Future<void> _updateRecipes() async {
    recipes = await RepositoriesManager()
        .getRecipeRepository()
        .advancedResearch(
            name: _searchText,
            filters: _filters.values.whereType<Filter>().toList());
    notifyListeners();
  }

  Future<void> addFilter(FilterType type, Filter? filter) async {
    _filters[type] = filter;
    await _updateRecipes();
  }

  Future<void> onSearchTextChanged(String value) async {
    _searchText = value;
    await _updateRecipes();
  }
}
