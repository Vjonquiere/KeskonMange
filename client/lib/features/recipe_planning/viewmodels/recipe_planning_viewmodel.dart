import 'package:client/core/message.dart';
import 'package:client/core/message_bus.dart';
import 'package:client/core/view_model.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/features/recipe_creation/viewmodels/ingredients_viewmodel.dart';
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_planning/models/meal_configuration.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/specifications.dart';
import 'package:flutter/cupertino.dart';

enum PlanningStep { calendar, config, review }

class RecipePlanningViewModel extends ViewModel {
  final List<MealSlot> _meals = Day.values
      .expand((day) => Meal.values.map((meal) => MealSlot(day, meal)))
      .toList();
  final IngredientsViewModel ingredientsViewModel = IngredientsViewModel();
  List<MealConfiguration> _configuredMeals = [];
  int _currentMealIndex = 0;
  bool _keepValuesForNextTimes = false;
  PlanningStep _currentStep = PlanningStep.calendar;
  Map<MealConfiguration, RecipePreview> _generatedRecipes = {};

  List<MealSlot> get meals => _meals;
  bool get keepValuesForNextTimes => _keepValuesForNextTimes;
  PlanningStep get currentStep => _currentStep;
  MealConfiguration get currentMealConfiguration =>
      _configuredMeals[_currentMealIndex].clone();
  int get mealToConfigure => _configuredMeals.length;
  int get currentMealIndex => _currentMealIndex + 1;
  Map<MealConfiguration, RecipePreview> get generateRecipes =>
      _generatedRecipes;

  void _onIngredientsChanged() {
    notifyListeners();
  }

  RecipePlanningViewModel() {
    ingredientsViewModel.addListener(_onIngredientsChanged);
  }

  void onMealSlotValueChanged(int index, bool value) {
    _meals[index].selected = value;
    notifyListeners();
  }

  void onKeepValuesForNextTimesChanged(bool? value) {
    _keepValuesForNextTimes = value!;
    notifyListeners();
  }

  void onNextStepPressed() {
    _configuredMeals.clear();
    for (MealSlot meal in _meals) {
      if (meal.selected) {
        _configuredMeals.add(MealConfiguration(meal.day, meal.meal));
      }
      _currentMealIndex = 0;
    }
    _configuredMeals.isEmpty
        ? _currentStep = PlanningStep.calendar
        : _currentStep = PlanningStep.config;
    if (_configuredMeals.isEmpty) {
      MessageBus.instance.addMessage(
          Message(MessageType.error, "You must select at least one meal"));
    }
    notifyListeners();
  }

  void _updateMealCourseOfCurrentConfiguration(
      MealCourse mealCourse, bool? value) {
    if (value == null) {
      return;
    }
    if (value &&
        !_configuredMeals[_currentMealIndex].courses.contains(mealCourse)) {
      _configuredMeals[_currentMealIndex].courses.add(mealCourse);
    }
    if (!value &&
        _configuredMeals[_currentMealIndex].courses.contains(mealCourse)) {
      _configuredMeals[_currentMealIndex].courses.remove(mealCourse);
    }
  }

  void setCurrentConfigurationStarterValue(bool? value) {
    _updateMealCourseOfCurrentConfiguration(MealCourse.starter, value);
    notifyListeners();
  }

  void setCurrentConfigurationMainCourseValue(bool? value) {
    _updateMealCourseOfCurrentConfiguration(MealCourse.main, value);
    notifyListeners();
  }

  void setCurrentConfigurationDessertValue(bool? value) {
    _updateMealCourseOfCurrentConfiguration(MealCourse.dessert, value);
    notifyListeners();
  }

  void increaseCurrentConfigurationPortions() {
    _configuredMeals[_currentMealIndex].portions++;
    notifyListeners();
  }

  void decreaseCurrentConfigurationPortions() {
    if (_configuredMeals[_currentMealIndex].portions <= 1) {
      return;
    }
    _configuredMeals[_currentMealIndex].portions--;
    notifyListeners();
  }

  void updateCurrentConfigurationCookingTime(int value) {
    _configuredMeals[_currentMealIndex].cookingTime = value;
    notifyListeners();
  }

  void updateFoodPreferences(Set<FoodPreference> values) {
    _configuredMeals[_currentMealIndex].foodPreferences = values;
    notifyListeners();
  }

  void updateCurrentConfigurationManuallySelectedRecipes(
      Set<RecipePreview> recipes) {
    _configuredMeals[_currentMealIndex].manuallySelectedRecipeIndex = recipes;
  }

  void onNextMealConfigurationPressed() async {
    if (_currentMealIndex >= _configuredMeals.length - 1) {
      await _fetchRecipes();
      _currentStep = PlanningStep.review;
    }
    _currentMealIndex++;
    notifyListeners();
  }

  void onPreviousMealConfigurationPressed() {
    if (_currentMealIndex < 1) {
      _currentStep = PlanningStep.calendar;
    } else {
      _currentMealIndex--;
    }
    notifyListeners();
  }

  Future<void> _fetchRecipes() async {
    int index = 0; // TODO: replace with real request
    for (MealConfiguration mealConfiguration in _configuredMeals) {
      if (mealConfiguration.manuallySelectedRecipeIndex != null) {
        _generatedRecipes[mealConfiguration] =
            mealConfiguration.manuallySelectedRecipeIndex!.first;
      } else {
        index++;
        final RecipePreview? generatedRecipe = await RepositoriesManager()
            .getRecipeRepository()
            .getRecipeFromId(index);
        if (generatedRecipe != null) {
          _generatedRecipes[mealConfiguration] = generatedRecipe;
        }
      }
    }
  }
}
