import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/book/complete.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/ViewModel.dart';

class BookViewModel extends ViewModel {
  int _bookId;
  late Book _book;
  List<RecipePreview> _recipePreviews = [];

  Book get book => _book;
  int get recipeCount => _recipePreviews.length;
  List<RecipePreview> get recipes => _recipePreviews;

  BookViewModel(this._bookId) {
    loadBook();
  }

  Future<void> loadBook() async {
    setStateValue(WidgetStates.loading);
    notifyListeners();
    Book? fetchedBook =
        await RepositoriesManager().getBookRepository().getBook(_bookId);
    if (fetchedBook == null) return;
    _book = fetchedBook;
    await loadRecipes();
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Future<void> loadRecipes() async {
    _recipePreviews.clear();
    for (int recipeId in _book.recipesIds) {
      RecipePreview? recipe = await RepositoriesManager()
          .getRecipeRepository()
          .getRecipeFromId(recipeId);
      if (recipe != null) _recipePreviews.add(recipe);
    }
  }

  Future<void> deleteBook() async {
    await RepositoriesManager().getBookRepository().deleteBook(_bookId);
  }
}
