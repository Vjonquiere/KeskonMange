import 'package:client/core/ViewModel.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/book/preview.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/material.dart';

class NewBookViewModel extends ViewModel {
  final TextEditingController _titleController = TextEditingController();
  bool _public = true;
  List<RecipePreview> _searchedRecipes = <RecipePreview>[];
  final List<int> _selectedRecipes = <int>[];

  TextEditingController get titleController => _titleController;
  bool get public => _public;
  List<RecipePreview> get searchedRecipes => _searchedRecipes;
  int get searchRecipesCount => _searchedRecipes.length;

  NewBookViewModel() {
    searchUpdate("");
  }

  void onPublicValueChanged(bool public) {
    _public = public;
    notifyListeners();
  }

  Future<bool> pushBook() async {
    final int bookId = await RepositoriesManager().getBookRepository().createNewBook(
        BookPreview(-1, _titleController.text, DateTime.now(), -1, _public),);
    for (int id in _selectedRecipes) {
      await RepositoriesManager()
          .getBookRepository()
          .addRecipeToBook(bookId, id);
    }
    return true;
  }

  void searchUpdate(String search) async {
    _searchedRecipes = await RepositoriesManager()
        .getRecipeRepository()
        .getRecipeMatchingName(search);
    notifyListeners();
  }

  bool isRecipeSelected(RecipePreview recipe) {
    return _selectedRecipes.contains(recipe.id);
  }

  void addRecipe(RecipePreview recipe) {
    _selectedRecipes.add(recipe.id);
    notifyListeners();
  }

  void removeRecipe(RecipePreview recipe) {
    if (!isRecipeSelected(recipe)) return;
    _selectedRecipes.remove(recipe.id);
    notifyListeners();
  }
}
