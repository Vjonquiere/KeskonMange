import 'dart:collection';

import 'package:client/core/state_viewmodel.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:client/model/recipe/preview.dart';

import '../../../model/recipe/recipe.dart';
import '../../../model/recipe/step.dart';

class RecipeReviewViewModel extends StateViewModel {
  late Recipe _recipe;
  late final HashMap<Ingredient, IngredientQuantity> _ingredients = HashMap();

  RecipeReviewViewModel();

  RecipePreview get recipePreview => _recipe.recipePreview;
  HashMap<Ingredient, IngredientQuantity> get ingredients => _ingredients;
  int get portions => _recipe.portions;
  List<Step> get steps => _recipe.steps;

  void setRecipe(Recipe recipe) {
    setStateValue(WidgetStates.loading);
    notifyListeners();
    _recipe = recipe;
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    for (IngredientQuantity ingredient in _recipe.ingredients) {
      final Ingredient? fetchedIngredient = await RepositoriesManager()
          .getIngredientRepository()
          .getIngredientFromId(ingredient.ingredientId);
      if (fetchedIngredient != null) {
        _ingredients[fetchedIngredient] = ingredient;
      }
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  @override
  Future<bool> isValid() async {
    return true;
  }
}
