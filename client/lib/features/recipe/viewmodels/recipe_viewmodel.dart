import 'package:client/core/message_bus.dart';
import 'package:client/core/view_model.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/recipe/recipe.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/message.dart';

class RecipeViewModel extends ViewModel {
  final int _recipeId;
  late Recipe _recipe;
  bool _expanded = false;

  RecipeViewModel(this._recipeId) {
    fetchRecipe();
  }

  Recipe get recipe => _recipe;
  bool get ingredientsExpanded => _expanded;

  void fetchRecipe() async {
    final Recipe? fetchedRecipe = await RepositoriesManager()
        .getRecipeRepository()
        .getCompleteRecipe(_recipeId);
    if (fetchedRecipe == null) {
      MessageBus.instance
          .addMessage(Message(MessageType.error, "Recipe not found"));
      return;
    }
    _recipe = fetchedRecipe;
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  void switchIngredientsExpanded() {
    _expanded = !_expanded;
    notifyListeners();
  }
}
