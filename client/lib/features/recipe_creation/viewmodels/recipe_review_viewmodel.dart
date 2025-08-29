import 'dart:collection';

import 'package:client/core/state_viewmodel.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:client/model/recipe/preview.dart';

import '../../../model/recipe/recipe.dart';
import '../../../model/recipe/step.dart';

class RecipeReviewViewModel extends StateViewModel {
  late Recipe _recipe;

  RecipeReviewViewModel();

  RecipePreview get recipePreview => _recipe.recipePreview;
  HashMap<Ingredient, IngredientQuantity> get ingredients =>
      _recipe.ingredients;
  int get portions => _recipe.portions;
  List<Step> get steps => _recipe.steps;

  void setRecipe(Recipe recipe) {
    _recipe = recipe;
  }

  @override
  Future<bool> isValid() async {
    return true;
  }
}
