import 'package:client/core/message_bus.dart';
import 'package:client/core/view_model.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/recipe/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/message.dart';

class RecipeViewModel extends ViewModel {
  final int _recipeId;
  late Recipe _recipe;
  DateTime? selectedPlanningDate = null;
  List<DateTime> _allCalendarEntries = [];
  bool _expanded = false;

  RecipeViewModel(this._recipeId) {
    fetchRecipe();
    _fetchCalendar();
  }

  Recipe get recipe => _recipe;
  bool get ingredientsExpanded => _expanded;
  DateTime? get nextTimePlanned =>
      _allCalendarEntries.isNotEmpty ? _allCalendarEntries.first : null;
  int get calendarEntriesCount => _allCalendarEntries.length;
  List<DateTime> get calendarEntries => _allCalendarEntries;

  void _fetchCalendar() async {
    _allCalendarEntries = await RepositoriesManager()
        .getCalendarRepository()
        .getDateFromPlannedRecipe(_recipeId);
    notifyListeners();
  }

  void fetchRecipe() async {
    final Recipe? fetchedRecipe = await RepositoriesManager()
        .getRecipeRepository()
        .getCompleteRecipe(_recipeId);
    if (fetchedRecipe == null) {
      MessageBus.instance
          .addMessage(Message(MessageType.error, "Recipe not found"));
      return;
    }
    _recipe = fetchedRecipe;
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  void switchIngredientsExpanded() {
    _expanded = !_expanded;
    notifyListeners();
  }

  void updateSelectedDate(DateTime? value) {
    selectedPlanningDate = value;
    notifyListeners();
  }

  void addToCalendar() {
    if (selectedPlanningDate == null) return;
    RepositoriesManager().getCalendarRepository().addNewRecipeToCalendar(
        DateTime(selectedPlanningDate!.year, selectedPlanningDate!.month,
            selectedPlanningDate!.day, 19),
        _recipeId);
    _fetchCalendar();
  }

  Future<void> removeFromCalendar(DateTime date) async {
    if (await RepositoriesManager()
        .getCalendarRepository()
        .removePlannedRecipeFromCalendar(date, _recipeId)) {
      _fetchCalendar();
    }
  }

  Future<void> updatePlannedRecipeTime(DateTime date, TimeOfDay newTime) async {
    if (await RepositoriesManager().getCalendarRepository().updatePlannedRecipe(
        date,
        DateTime(date.year, date.month, date.day, newTime.hour, newTime.minute),
        _recipeId)) {
      _fetchCalendar();
    }
  }
}
