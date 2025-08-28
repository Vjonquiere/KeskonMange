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
  late Set<UnitCategory> _selectedUnit;
  late Unit _selectedDetailedUnit;
  final List<DropdownMenuItem<Unit>> _items = [];
  HashMap<Ingredient, IngredientQuantity> values = HashMap();
  final TextEditingController _quantityController = TextEditingController();

  List<Ingredient> get ingredients => _ingredients;
  int get currentIndex => _currentIndex;
  Ingredient get currentIngredient => _currentIngredient;
  Set<UnitCategory> get selectedUnit => _selectedUnit;
  Unit get selectedDetailedUnit => _selectedDetailedUnit;
  List<DropdownMenuItem<Unit>> get items => _items;
  List<ButtonSegment<UnitCategory>> get getTypeSelection => _getTypeSelection();
  TextEditingController get quantityController => _quantityController;

  void setIngredients(List<Ingredient> ingredients) {
    _ingredients = ingredients;
    _currentIngredient = ingredients[0];
    _selectedUnit = {_currentIngredient.type.first.unitCategory};
    updateUnits(setDetailedUnit: true);
    _selectedDetailedUnit = _items.first.value!;
    notifyListeners();
  }

  void previousIngredient() {
    if (_currentIndex <= 0) return;
    values[_currentIngredient] = IngredientQuantity(
        _selectedDetailedUnit, int.parse(_quantityController.text));
    _currentIndex--;
    _currentIngredient = ingredients[_currentIndex];

    if (values.containsKey(_currentIngredient)) {
      _selectedUnit = {values[_currentIngredient]!.unit.unitCategory};
      _quantityController.text =
          values[_currentIngredient]!.quantity.toString();
      _selectedDetailedUnit = values[_currentIngredient]!.unit;
    } else {
      _quantityController.text = "";
      _selectedUnit = {_currentIngredient.type.first.unitCategory};
      _selectedDetailedUnit = _items.first.value!;
    }
    updateUnits();
    notifyListeners();
  }

  void nextIngredient() {
    if (_currentIndex >= ingredients.length - 1 ||
        int.tryParse(_quantityController.text) == null) return;
    values[_currentIngredient] = IngredientQuantity(
        _selectedDetailedUnit, int.parse(_quantityController.text));
    _currentIndex++;
    _currentIngredient = ingredients[_currentIndex];

    if (values.containsKey(_currentIngredient)) {
      _selectedUnit = {values[_currentIngredient]!.unit.unitCategory};
      _quantityController.text =
          values[_currentIngredient]!.quantity.toString();
      _selectedDetailedUnit = values[_currentIngredient]!.unit;
    } else {
      _quantityController.text = "";
      _selectedUnit = {_currentIngredient.type.first.unitCategory};
      _selectedDetailedUnit = _items.first.value!;
    }
    updateUnits();
    notifyListeners();
  }

  void updateUnits({setDetailedUnit = false}) {
    _items.clear();
    if (_selectedUnit.first == UnitCategory.volume) {
      _items.addAll(VolumeUnits.values.map((elt) => DropdownMenuItem(
          value: Unit(UnitCategory.volume, elt), child: Text(elt.name))));
    } else if (_selectedUnit.first == UnitCategory.special) {
      _items.addAll(SpecialUnits.values.map((elt) => DropdownMenuItem(
          value: Unit(UnitCategory.special, elt), child: Text(elt.name))));
    } else if (_selectedUnit.first == UnitCategory.weight) {
      _items.addAll(WeightUnits.values.map((elt) => DropdownMenuItem(
          value: Unit(UnitCategory.weight, elt), child: Text(elt.name))));
    } else if (_selectedUnit.first == UnitCategory.wholeItem) {
      _items.addAll(WholeItemsUnits.values.map((elt) => DropdownMenuItem(
          value: Unit(UnitCategory.wholeItem, elt), child: Text(elt.name))));
    } else {
      throw Exception("");
    }
    if (setDetailedUnit) {
      _selectedDetailedUnit = _items.first.value!;
    }
  }

  List<ButtonSegment<UnitCategory>> _getTypeSelection() {
    List<ButtonSegment<UnitCategory>> types = [];
    for (Unit unit in _currentIngredient.type) {
      types.add(ButtonSegment(
          value: unit.unitCategory, label: Text(unit.toString())));
    }
    return types;
  }

  void updateSelectedUnit(Set<UnitCategory> unit) {
    _selectedUnit = unit;
    updateUnits(setDetailedUnit: true);
    notifyListeners();
  }

  void updateDetailedSelectedUnit(Unit? unit) {
    if (unit == null) return;
    _selectedDetailedUnit = unit;
    notifyListeners();
  }

  @override
  Future<bool> isValid() async {
    if (_ingredients.length != values.length) return false;
    return true;
  }
}
