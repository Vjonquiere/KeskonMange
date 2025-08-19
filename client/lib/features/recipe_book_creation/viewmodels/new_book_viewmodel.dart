import 'package:client/core/ViewModel.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/http/authentication.dart';
import 'package:client/model/book/preview.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/user.dart';
import 'package:flutter/material.dart';

class NewBookViewModel extends ViewModel {
  final TextEditingController _titleController = TextEditingController();
  bool _public = true;
  List<RecipePreview> _searchedRecipes = [];
  List<int> _selectedRecipes = [];

  TextEditingController get titleController => _titleController;
  bool get public => _public;
  List<RecipePreview> get searchedRecipes => _searchedRecipes;
  int get searchRecipesCount => _searchedRecipes.length;

  void onPublicValueChanged(bool public) {
    _public = public;
    notifyListeners();
  }

  void pushBook() {
    RepositoriesManager().getBookRepository().createNewBook(
        BookPreview(-1, _titleController.text, DateTime.now(), -1, _public));
  }

  void searchUpdate(String search) async {
    _searchedRecipes = await RepositoriesManager()
        .getRecipeRepository()
        .getRecipeMatchingName(search);
    notifyListeners();
  }
}
