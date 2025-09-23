import 'dart:convert';
import 'package:client/config.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/book/complete.dart';
import '../model/recipe/recipe.dart';

class MockRepositoriesSampleLoad {
  MockRepositoriesSampleLoad._();

  static Future<MockRepositoriesSampleLoad> create() async {
    final MockRepositoriesSampleLoad repo = MockRepositoriesSampleLoad._();
    await repo._loadSamples();
    return repo;
  }

  Future<void> _loadSamples() async {
    for (String source in Config().mockSampleFiles) {
      try {
        String content;

        if (source.startsWith("http://") || source.startsWith("https://")) {
          final http.Response response = await http.get(Uri.parse(source));
          if (response.statusCode == 200) {
            content = response.body;
          } else {
            throw Exception("HTTP ${response.statusCode}");
          }
        } else {
          content = await rootBundle.loadString(source);
        }

        final dynamic decoded = jsonDecode(content);
        _loadIngredients(_extractIngredients(decoded));
        _loadRecipes(_extractRecipes(decoded));
        _loadBooks(_extractBooks(decoded));
      } catch (e) {
        debugPrint("Can't load source [$source]: $e");
        break;
      }
    }
    WidgetsFlutterBinding.ensureInitialized();
    await openDatabase(join(await getDatabasesPath(), 'calendar.db'),
        onCreate: (Database db, int version) {
      return db
          .execute('CREATE TABLE calendar(date INTEGER, recipe_id INTEGER)');
    }, version: 1);
  }

  List<dynamic> _extractRecipes(Map<String, dynamic> fileContent) {
    if (fileContent.containsKey("recipes")) {
      return fileContent["recipes"] as List<dynamic>;
    }
    throw const FormatException("Mock file can't be loaded: no recipes found");
  }

  List<dynamic> _extractIngredients(Map<String, dynamic> fileContent) {
    if (fileContent.containsKey("ingredients")) {
      return fileContent["ingredients"] as List<dynamic>;
    }
    throw const FormatException(
      "Mock file can't be loaded: no ingredients found",
    );
  }

  List<dynamic> _extractBooks(Map<String, dynamic> fileContent) {
    if (fileContent.containsKey("books")) {
      return fileContent["books"] as List<dynamic>;
    }
    throw const FormatException("Mock file can't be loaded: no books found");
  }

  void _loadRecipes(List<dynamic> recipes) {
    int loadedRecipes = 0;
    for (dynamic recipe in recipes) {
      try {
        final Recipe loadedRecipe = Recipe.fromJson(recipe);
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
        final Ingredient loadedIngredient = Ingredient.fromJson(ingredient);
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
        final Book loadedBook = Book.fromJson(book);
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
