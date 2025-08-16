import 'package:client/data/repositories/book_repository.dart';
import 'package:client/data/repositories/impl/api/ingredient_repository_api.dart';
import 'package:client/data/repositories/impl/mock/book_repository_mock.dart';
import 'package:client/data/repositories/impl/mock/calendar_repository_mock.dart';
import 'package:client/data/repositories/impl/mock/ingredient_repository_mock.dart';
import 'package:client/data/repositories/impl/mock/recipe_repository_mock.dart';
import 'package:client/data/repositories/impl/mock/user_repository_mock.dart';
import 'package:client/data/repositories/ingredient_repository.dart';
import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/data/repositories/user_repository.dart';

import 'calendar_repository.dart';
import 'impl/api/book_repository_api.dart';
import 'impl/api/calendar_repository_api.dart';
import 'impl/api/recipe_repository_api.dart';
import 'impl/api/user_repository_api.dart';

class RepositoriesManager {
  static final RepositoriesManager _instance = RepositoriesManager._internal();
  factory RepositoriesManager() => _instance;
  RepositoriesManager._internal();
  bool _useMockRepositories = false;

  bool get currentlyUsingMockRepositories => _useMockRepositories;

  late BookRepository _bookRepository;
  late CalendarRepository _calendarRepository;
  late RecipeRepository _recipeRepository;
  late UserRepository _userRepository;
  late IngredientRepository _ingredientRepository;

  void useMockRepositories() {
    _bookRepository = BookRepositoryMock();
    _calendarRepository = CalendarRepositoryMock();
    _recipeRepository = RecipeRepositoryMock();
    _userRepository = UserRepositoryMock();
    _ingredientRepository = IngredientRepositoryMock();
    _useMockRepositories = true;
  }

  void useApiRepositories() {
    _bookRepository = BookRepositoryApi();
    _calendarRepository = CalendarRepositoryApi();
    _recipeRepository = RecipeRepositoryApi();
    _userRepository = UserRepositoryApi();
    _ingredientRepository = IngredientRepositoryApi();
    _useMockRepositories = false;
  }

  BookRepository getBookRepository() => _bookRepository;
  CalendarRepository getCalendarRepository() => _calendarRepository;
  RecipeRepository getRecipeRepository() => _recipeRepository;
  UserRepository getUserRepository() => _userRepository;
  IngredientRepository getIngredientRepository() => _ingredientRepository;
}
