import 'dart:convert';
import 'dart:io';

import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/foundation.dart';
import 'package:client/variables.dart' as variables;
import 'package:flutter/services.dart';

class MockRepositoriesSampleLoad {
  MockRepositoriesSampleLoad._();

  static Future<MockRepositoriesSampleLoad> create() async {
    final repo = MockRepositoriesSampleLoad._();
    await repo._loadSamples();
    return repo;
  }

  Future<void> _loadSamples() async {
    for (String file in variables.mockSampleFiles) {
      try {
        String content = await rootBundle.loadString(file);
        _loadRecipes(_extractRecipes(jsonDecode(content)));
        _loadIngredients(_extractIngredients(jsonDecode(content)));
      } catch (e) {
        debugPrint("Can't load file [$file]: $e");
        break;
      }
    }
  }

  List<dynamic> _extractRecipes(Map<String, dynamic> fileContent) {
    if (fileContent.containsKey("recipes"))
      return fileContent["recipes"] as List;
    throw const FormatException("Mock file can't be loaded: no recipes found");
  }

  List<dynamic> _extractIngredients(Map<String, dynamic> fileContent) {
    if (fileContent.containsKey("ingredients"))
      return fileContent["ingredients"] as List;
    throw const FormatException(
        "Mock file can't be loaded: no ingredients found");
  }

  void _loadRecipes(List<dynamic> recipes) {
    int loadedRecipes = 0;
    for (dynamic recipe in recipes) {
      try {
        RecipePreview loadedRecipe = RecipePreview.fromJson(recipe);
        RepositoriesManager()
            .getRecipeRepository()
            .createNewRecipe(loadedRecipe);
        loadedRecipes++;
      } on Exception catch (_) {
        debugPrint("1 recipe cant be loaded ($recipe)");
      }
    }

    debugPrint("$loadedRecipes recipes were loaded from sample file");
  }

  void _loadIngredients(List<dynamic> ingredients) {
    int loadedIngredients = 0;
    for (dynamic ingredient in ingredients) {
      try {
        Ingredient loadedIngredient = Ingredient.fromJson(ingredient);
        RepositoriesManager()
            .getIngredientRepository()
            .createIngredient(loadedIngredient);
        loadedIngredients++;
      } on Exception catch (_) {
        debugPrint("1 ingredient cant be loaded ($ingredient)");
      }
    }
    debugPrint("$loadedIngredients ingredients were loaded from sample file");
  }
}
