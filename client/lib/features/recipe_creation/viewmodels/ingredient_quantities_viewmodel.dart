import 'dart:collection';

import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../model/ingredient.dart';
import '../../../model/ingredient_quantity.dart';
import '../../../model/ingredient_units.dart';

class IngredientQuantitiesViewModel extends StateViewModel {
  List<Ingredient> _ingredients = [];
  int _currentIndex = 0;
  late Ingredient _currentIngredient;
  late Set<Unit> _selectedUnit;
  late Unit _selectedDetailedUnit;
  List<DropdownMenuItem<Unit>> _items = [];
  HashMap<Ingredient, IngredientQuantity> values = HashMap();

  List<Ingredient> get ingredients => _ingredients;
  int get currentIndex => _currentIndex;
  Ingredient get currentIngredient => _currentIngredient;
  Set<Unit> get selectedUnit => _selectedUnit;
  Unit get selectedDetailedUnit => _selectedDetailedUnit;
  List<DropdownMenuItem<Unit>> get items => _items;
  List<ButtonSegment<Unit>> get getTypeSelection => _getTypeSelection();

  void setIngredients(List<Ingredient> ingredients) {
    _ingredients = ingredients;
    _currentIngredient = ingredients[0];
    _selectedUnit = {_currentIngredient.type.first};
    _selectedDetailedUnit = _selectedUnit.first;
    updateUnits();
    notifyListeners();
  }

  void previousIngredient() {
    if (_currentIndex <= 0) return;
    values[_currentIngredient] = IngredientQuantity(_selectedUnit.first, 0);
    _currentIndex--;
    _currentIngredient = ingredients[_currentIndex];
    if (values.containsKey(_currentIngredient)) {
      _selectedUnit = {values[_currentIngredient]!.unit};
    } else {
      _selectedUnit = {_currentIngredient.type.first};
    }
    updateUnits();
    notifyListeners();
  }

  void nextIngredient() {
    if (_currentIndex >= ingredients.length - 1) return;
    values[_currentIngredient] = IngredientQuantity(_selectedUnit.first, 0);
    _currentIndex++;
    _currentIngredient = ingredients[_currentIndex];
    if (values.containsKey(_currentIngredient)) {
      _selectedUnit = {values[_currentIngredient]!.unit};
    } else {
      _selectedUnit = {_currentIngredient.type.first};
    }
    updateUnits();
    notifyListeners();
  }

  void updateUnits() {
    _items.clear();
    if (_selectedUnit.first is VolumeUnit) {
      _items.addAll(VolumeUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else if (_selectedUnit.first is SpecialUnit) {
      _items.addAll(SpecialUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else if (_selectedUnit.first is WeightUnit) {
      _items.addAll(WeightUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else if (_selectedUnit.first is WholeUnit) {
      _items.addAll(WholeItemsUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else {
      throw Exception("");
    }
    _selectedDetailedUnit = _items.first.value!;
    notifyListeners();
  }

  List<ButtonSegment<Unit>> _getTypeSelection() {
    List<ButtonSegment<Unit>> types = [];
    for (Unit unit in _currentIngredient.type) {
      types.add(ButtonSegment(value: unit, label: Text(unit.toString())));
    }
    return types;
  }

  void updateSelectedUnit(Set<Unit> unit) {
    _selectedUnit = unit;
    updateUnits();
  }

  void updateDetailedSelectedUnit(Unit? unit) {
    if (unit == null) return;
    _selectedDetailedUnit = unit;
    debugPrint(unit.toString());
    notifyListeners();
  }

  @override
  Future<bool> isValid() async {
    return true;
  }
}
