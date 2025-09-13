import 'package:client/core/view_model.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/cupertino.dart';

class RecipeSelectionViewModel extends ViewModel {
  TextEditingController _queryController = TextEditingController();
  List<RecipePreview> _fetchedRecipes = <RecipePreview>[];

  TextEditingController get queryController => _queryController;
  List<RecipePreview> get fetchedRecipes => _fetchedRecipes;

  void onQueryChanged(String query) async {
    final List<RecipePreview> recipes = await RepositoriesManager()
        .getRecipeRepository()
        .getRecipeMatchingName(query, count: 10);
    _fetchedRecipes = recipes;
    debugPrint(query);
    debugPrint("RECIPES COUNT: ${fetchedRecipes.length}");
    notifyListeners();
  }
}
