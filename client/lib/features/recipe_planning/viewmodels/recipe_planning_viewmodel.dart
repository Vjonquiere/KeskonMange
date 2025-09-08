import 'package:client/core/message.dart';
import 'package:client/core/message_bus.dart';
import 'package:client/core/view_model.dart';
import 'package:client/features/recipe_creation/viewmodels/ingredients_viewmodel.dart';
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_planning/models/meal_configuration.dart';
import 'package:client/model/recipe/specifications.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/ingredient.dart';

class RecipePlanningViewModel extends ViewModel {
  final List<MealSlot> _meals = Day.values
      .expand((day) => Meal.values.map((meal) => MealSlot(day, meal)))
      .toList();
  final IngredientsViewModel ingredientsViewModel = IngredientsViewModel();
  List<MealConfiguration> _configuredMeals = [];
  int _currentMealIndex = 0;
  bool _keepValuesForNextTimes = false;
  bool _weeklyPlanningStep = true;

  List<MealSlot> get meals => _meals;
  bool get keepValuesForNextTimes => _keepValuesForNextTimes;
  bool get weeklyPlanningStep => _weeklyPlanningStep;
  MealConfiguration get currentMealConfiguration =>
      _configuredMeals[_currentMealIndex].clone();

  void _onIngredientsChanged() {
    notifyListeners();
  }

  RecipePlanningViewModel() {
    ingredientsViewModel.addListener(_onIngredientsChanged);
  }

  void onMealSlotValueChanged(int index, bool value) {
    debugPrint(index.toString());
    _meals[index].selected = value;
    notifyListeners();
  }

  void onKeepValuesForNextTimesChanged(bool? value) {
    _keepValuesForNextTimes = value!;
    notifyListeners();
  }

  void onNextStepPressed() {
    for (MealSlot meal in _meals) {
      if (meal.selected) {
        _configuredMeals.add(MealConfiguration(meal.day, meal.meal));
      }
      _currentMealIndex = 0;
    }
    _configuredMeals.isEmpty
        ? _weeklyPlanningStep = true
        : _weeklyPlanningStep = false;
    if (_configuredMeals.isEmpty) {
      MessageBus.instance.addMessage(
          Message(MessageType.error, "You must select at least one meal"));
    }
    notifyListeners();
  }

  void _updateMealCourseOfCurrentConfiguration(
      MealCourse mealCourse, bool? value) {
    if (value == null) {
      debugPrint("null");
      return;
    }
    if (value &&
        !_configuredMeals[_currentMealIndex].courses.contains(mealCourse)) {
      debugPrint("Added");
      _configuredMeals[_currentMealIndex].courses.add(mealCourse);
    }
    if (!value &&
        _configuredMeals[_currentMealIndex].courses.contains(mealCourse)) {
      debugPrint("Removes");
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
}
