import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/book/complete.dart';
import 'package:client/model/recipe/preview.dart';

import '../../../core/view_model.dart';

class BookViewModel extends ViewModel {
  final int _bookId;
  late Book _book;
  final List<RecipePreview> _recipePreviews = <RecipePreview>[];
  bool _editMode = false;

  Book get book => _book;
  int get recipeCount => _recipePreviews.length;
  List<RecipePreview> get recipes => _recipePreviews;
  bool get editMode => _editMode;

  BookViewModel(this._bookId) {
    loadBook();
  }

  Future<void> loadBook() async {
    setStateValue(WidgetStates.loading);
    notifyListeners();
    final Book? fetchedBook =
        await RepositoriesManager().getBookRepository().getBook(_bookId);
    if (fetchedBook == null) {
      return;
    }
    _book = fetchedBook;
    await loadRecipes();
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Future<void> loadRecipes() async {
    _recipePreviews.clear();
    for (int recipeId in _book.recipesIds) {
      final RecipePreview? recipe = await RepositoriesManager()
          .getRecipeRepository()
          .getRecipeFromId(recipeId);
      if (recipe != null) {
        _recipePreviews.add(recipe);
      }
    }
  }

  Future<void> deleteBook() async {
    await RepositoriesManager().getBookRepository().deleteBook(_bookId);
  }

  Future<void> deleteRecipe(int recipeId) async {
    await RepositoriesManager()
        .getBookRepository()
        .deleteRecipeFromBook(_bookId, recipeId);
    loadBook();
  }

  void switchEditMode() {
    _editMode = !_editMode;
    notifyListeners();
  }
}
