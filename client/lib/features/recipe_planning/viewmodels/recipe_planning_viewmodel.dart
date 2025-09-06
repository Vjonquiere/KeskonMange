import 'package:client/core/view_model.dart';
import 'package:client/features/recipe_creation/viewmodels/ingredients_viewmodel.dart';
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/ingredient.dart';

class RecipePlanningViewModel extends ViewModel {
  final List<MealSlot> _meals = Day.values
      .expand((day) => Meal.values.map((meal) => MealSlot(day, meal)))
      .toList();
  final IngredientsViewModel ingredientsViewModel = IngredientsViewModel();
  bool _keepValuesForNextTimes = false;

  List<MealSlot> get meals => _meals;
  bool get keepValuesForNextTimes => _keepValuesForNextTimes;

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
}
