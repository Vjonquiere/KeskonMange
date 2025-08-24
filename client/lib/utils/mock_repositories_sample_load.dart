import 'dart:convert';
import 'dart:io';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/foundation.dart';
import 'package:client/variables.dart' as variables;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/book/complete.dart';
import '../model/book/preview.dart';

class MockRepositoriesSampleLoad {
  MockRepositoriesSampleLoad._();

  static Future<MockRepositoriesSampleLoad> create() async {
    final repo = MockRepositoriesSampleLoad._();
    await repo._loadSamples();
    return repo;
  }

  Future<void> _loadSamples() async {
    for (String source in variables.mockSampleFiles) {
      try {
        String content;

        if (source.startsWith("http://") || source.startsWith("https://")) {
          final response = await http.get(Uri.parse(source));
          if (response.statusCode == 200) {
            content = response.body;
          } else {
            throw Exception("HTTP ${response.statusCode}");
          }
        } else {
          content = await rootBundle.loadString(source);
        }

        final decoded = jsonDecode(content);
        _loadRecipes(_extractRecipes(decoded));
        _loadIngredients(_extractIngredients(decoded));
        _loadBooks(_extractBooks(decoded));
      } catch (e) {
        debugPrint("Can't load source [$source]: $e");
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

  List<dynamic> _extractBooks(Map<String, dynamic> fileContent) {
    if (fileContent.containsKey("books")) return fileContent["books"] as List;
    throw const FormatException("Mock file can't be loaded: no books found");
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

  void _loadBooks(List<dynamic> books) {
    int loadedBooks = 0;
    for (dynamic book in books) {
      try {
        Book loadedBook = Book.fromJson(book);
        RepositoriesManager().getBookRepository().createNewBook(loadedBook);
        for (int recipeId in loadedBook.recipesIds) {
          RepositoriesManager()
              .getBookRepository()
              .addRecipeToBook(loadedBook.id, recipeId);
          //debugPrint("Recipe $recipeId added to book ${loadedBook.id}");
        }
        loadedBooks++;
      } on Exception catch (exception) {
        debugPrint("1 book cant be loaded ($book): $exception");
      }
    }
    debugPrint("$loadedBooks books were loaded from sample file");
  }
}
