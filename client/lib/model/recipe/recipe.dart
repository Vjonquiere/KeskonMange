import 'dart:collection';

import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/step.dart';

import '../ingredient.dart';
import '../ingredient_quantity.dart';

class Recipe {
  final RecipePreview _recipePreview;
  final HashMap<Ingredient, IngredientQuantity> _ingredients;
  final List<Step> _steps;
  final int _portions;

  Recipe(this._recipePreview, this._ingredients, this._portions, this._steps);

  RecipePreview get recipePreview => _recipePreview;
  HashMap<Ingredient, IngredientQuantity> get ingredients => _ingredients;
  List<Step> get steps => _steps;
  int get portions => _portions;
}
