import 'dart:collection';

import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient_units.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/step.dart';

import '../ingredient.dart';
import '../ingredient_quantity.dart';

class Recipe {
  final RecipePreview _recipePreview;
  final List<IngredientQuantity> _ingredients;
  final List<Step> _steps;
  final int _portions;

  Recipe(this._recipePreview, this._ingredients, this._portions, this._steps);

  RecipePreview get recipePreview => _recipePreview;
  List<IngredientQuantity> get ingredients => _ingredients;
  List<Step> get steps => _steps;
  int get portions => _portions;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "recipePreview": final Map<String, dynamic> recipePreview,
        "ingredients": final List<dynamic> ingredients,
        "steps": final List<dynamic> steps,
        "portions": final int portions,
      } =>
        Recipe(
            RecipePreview.fromJson(recipePreview),
            ingredients
                .map((dynamic ingredient) =>
                    IngredientQuantity.fromJson(ingredient))
                .toList(),
            portions,
            steps.map((dynamic step) => Step.fromJson(step)).toList()),
      _ => throw UnimplementedError(),
    };
  }
}
