import 'dart:collection';

import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../model/ingredient.dart';
import '../../../model/ingredient_quantity.dart';
import '../../../model/ingredient_units.dart';

class IngredientQuantitiesViewModel extends StateViewModel {
  List<Ingredient> _ingredients = <Ingredient>[];
  int _currentIndex = 0;
  late Ingredient _currentIngredient;
  late Set<UnitCategory> _selectedUnit;
  late Unit _selectedDetailedUnit;
  final List<DropdownMenuItem<Unit>> _items = <DropdownMenuItem<Unit>>[];
  HashMap<Ingredient, IngredientQuantity> values =
      HashMap<Ingredient, IngredientQuantity>();
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
    _selectedUnit = <UnitCategory>{_currentIngredient.type.first.unitCategory};
    updateUnits(setDetailedUnit: true);
    _selectedDetailedUnit = _items.first.value!;
    notifyListeners();
  }

  void _saveCurrentIngredientQuantity() {
    values[_currentIngredient] = IngredientQuantity(
      _currentIngredient.id,
      _selectedDetailedUnit,
      double.parse(_quantityController.text),
    );
  }

  void _loadIngredient(bool next) {
    _saveCurrentIngredientQuantity();
    next ? _currentIndex++ : _currentIndex--;
    _currentIngredient = ingredients[_currentIndex];

    if (values.containsKey(_currentIngredient)) {
      _selectedUnit = <UnitCategory>{
        values[_currentIngredient]!.unit.unitCategory
      };
      _quantityController.text =
          values[_currentIngredient]!.quantity.toString();
      _selectedDetailedUnit = values[_currentIngredient]!.unit;
      updateUnits();
    } else {
      _quantityController.text = "";
      _selectedUnit = <UnitCategory>{
        _currentIngredient.type.first.unitCategory
      };
      updateUnits(setDetailedUnit: true);
    }
  }

  void previousIngredient() {
    if (_currentIndex <= 0) {
      return;
    }
    _loadIngredient(false);
    notifyListeners();
  }

  void nextIngredient() {
    if (_currentIndex >= ingredients.length - 1 ||
        int.tryParse(_quantityController.text) == null) {
      return;
    }
    _loadIngredient(true);
    notifyListeners();
  }

  void updateUnits({bool setDetailedUnit = false}) {
    _items.clear();
    if (_selectedUnit.first == UnitCategory.volume) {
      _items.addAll(
        VolumeUnits.values.map(
          (VolumeUnits elt) => DropdownMenuItem<Unit>(
            value: Unit(UnitCategory.volume, elt),
            child: Text(elt.name),
          ),
        ),
      );
    } else if (_selectedUnit.first == UnitCategory.special) {
      _items.addAll(
        SpecialUnits.values.map(
          (SpecialUnits elt) => DropdownMenuItem<Unit>(
            value: Unit(UnitCategory.special, elt),
            child: Text(elt.name),
          ),
        ),
      );
    } else if (_selectedUnit.first == UnitCategory.weight) {
      _items.addAll(
        WeightUnits.values.map(
          (WeightUnits elt) => DropdownMenuItem<Unit>(
            value: Unit(UnitCategory.weight, elt),
            child: Text(elt.name),
          ),
        ),
      );
    } else if (_selectedUnit.first == UnitCategory.wholeItem) {
      _items.addAll(
        WholeItemsUnits.values.map(
          (WholeItemsUnits elt) => DropdownMenuItem<Unit>(
            value: Unit(UnitCategory.wholeItem, elt),
            child: Text(elt.name),
          ),
        ),
      );
    } else {
      throw Exception("");
    }
    if (setDetailedUnit) {
      _selectedDetailedUnit = _items.first.value!;
    }
  }

  List<ButtonSegment<UnitCategory>> _getTypeSelection() {
    final List<ButtonSegment<UnitCategory>> types =
        <ButtonSegment<UnitCategory>>[];
    for (Unit unit in _currentIngredient.type) {
      types.add(
        ButtonSegment<UnitCategory>(
          value: unit.unitCategory,
          label: Text(unit.toString()),
        ),
      );
    }
    return types;
  }

  void updateSelectedUnit(Set<UnitCategory> unit) {
    _selectedUnit = unit;
    updateUnits(setDetailedUnit: true);
    notifyListeners();
  }

  void updateDetailedSelectedUnit(Unit? unit) {
    if (unit == null) {
      return;
    }
    _selectedDetailedUnit = unit;
    notifyListeners();
  }

  @override
  Future<bool> isValid() async {
    _saveCurrentIngredientQuantity();
    if (_ingredients.length != values.length) {
      return false;
    }
    return true;
  }
}
