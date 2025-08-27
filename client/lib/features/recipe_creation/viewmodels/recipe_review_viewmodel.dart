import 'dart:collection';

import 'package:client/core/state_viewmodel.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:client/model/recipe/preview.dart';

class RecipeReviewViewModel extends StateViewModel {
  late RecipePreview _recipe;
  late HashMap<Ingredient, IngredientQuantity> _ingredients = HashMap();

  RecipeReviewViewModel();

  RecipePreview get recipe => _recipe;
  HashMap<Ingredient, IngredientQuantity> get ingredients => _ingredients;

  void setRecipe(RecipePreview recipe) {
    _recipe = recipe;
  }

  void setIngredients(HashMap<Ingredient, IngredientQuantity> ingredients) {
    _ingredients = ingredients;
  }

  @override
  Future<bool> isValid() async {
    return true;
  }
}
