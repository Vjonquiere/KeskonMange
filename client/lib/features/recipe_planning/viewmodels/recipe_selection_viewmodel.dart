import 'package:client/core/view_model.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/recipe/preview.dart';

class RecipeSelectionViewModel extends ViewModel {
  List<RecipePreview> _fetchedRecipes = <RecipePreview>[];
  Set<RecipePreview> _selectedRecipes = {};
  Function(Set<RecipePreview>)? updateManuallySelectedRecipes;

  RecipeSelectionViewModel({this.updateManuallySelectedRecipes});

  List<RecipePreview> get fetchedRecipes => _fetchedRecipes;
  Set<RecipePreview> get selectedRecipes => _selectedRecipes;

  void onQueryChanged(String query) async {
    final List<RecipePreview> recipes = await RepositoriesManager()
        .getRecipeRepository()
        .getRecipeMatchingName(query, count: 10);
    _fetchedRecipes = recipes;
    notifyListeners();
  }

  void switchRecipeSelection(RecipePreview recipe) {
    if (!_selectedRecipes.remove(recipe)) {
      _selectedRecipes.add(recipe);
    }
    if (updateManuallySelectedRecipes != null) {
      updateManuallySelectedRecipes!(_selectedRecipes);
    }
    notifyListeners();
  }
}
