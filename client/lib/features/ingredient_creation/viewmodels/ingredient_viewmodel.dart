import 'package:client/constants.dart';
import 'package:client/core/ViewModel.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';
import 'package:client/features/ingredient_creation/model/cereal_starches_category.dart';
import 'package:client/features/ingredient_creation/model/dairy_products_category.dart';
import 'package:client/features/ingredient_creation/model/drinks_category.dart';
import 'package:client/features/ingredient_creation/model/fat_category.dart';
import 'package:client/features/ingredient_creation/model/fruit_vegetable_category.dart';
import 'package:client/features/ingredient_creation/model/meat_category.dart';
import 'package:client/features/ingredient_creation/model/sweets_category.dart';
import 'package:client/model/ingredient.dart';
import 'package:flutter/material.dart';

import '../../../model/ingredient_units.dart';

class IngredientCreationViewModel extends ViewModel {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _specifications = ["vegetarian", "vegan"];
  Set<String> _selectedSpecifications = {};
  final List<IngredientCategory> _categories = [
    CerealStarchesCategory(),
    DairyProductsCategory(),
    DrinksCategory(),
    FatCategory(),
    FruitVegetableCategory(),
    MeatCategory(),
    SweetsCategory()
  ];
  late IngredientCategory _selectedCategory = _categories.first;
  int _selectedSubCategoryIndex = 0;
  List<bool> _allergens = List.generate(allergens.length, (e) => false);
  Set<String> _selectedUnits = {units.values.first.toString()};

  TextEditingController get nameController => _nameController;

  List<String> get specifications => _specifications;
  int get specificationsCount => _specifications.length;
  Set<String> get selectedSpecifications => _selectedSpecifications;

  List<IngredientCategory> get categories => _categories;
  int get categoriesCount => _categories.length;
  Set<String> get selectedCategoryString => {_selectedCategory.toString()};
  IngredientCategory get selectedCategory => _selectedCategory;
  int get selectedSubCategoryIndex => _selectedSubCategoryIndex;
  List<bool> get selectedSubCategories => List.generate(
      _selectedCategory.getSubCategories().length,
      (int index) => index == _selectedSubCategoryIndex ? true : false);

  List<bool> get allergensValues => _allergens;
  Set<String> get selectedUnits => _selectedUnits;

  IngredientCreationViewModel();

  void updateSelectedCategory(Set<String> selectedCategoryString) {
    for (IngredientCategory category in _categories) {
      if (category.toString() == selectedCategoryString.first) {
        _selectedCategory = category;
        _selectedSubCategoryIndex = 0;
      }
    }
    notifyListeners();
  }

  void updateSelectedSpecifications(Set<String> selectedSpecifications) {
    _selectedSpecifications = selectedSpecifications;
    notifyListeners();
  }

  void updateSelectedSubCategory(int index) {
    _selectedSubCategoryIndex = index;
    notifyListeners();
  }

  void switchSelectedAllergen(int index, bool value) {
    _allergens[index] = value;
    notifyListeners();
  }

  void updateSelectedUnits(Set<String> selectedUnits) {
    _selectedUnits = selectedUnits;
    notifyListeners();
  }

  void pushIngredient() async {
    // TODO: test data valid
    int status = await RepositoriesManager()
        .getIngredientRepository()
        .createIngredient(Ingredient(
            _nameController.text,
            _selectedUnits
                .map((element) => getUnitFromString(element))
                .toList()));
    if (status != 200) {
      // TODO: error management
    }
  }
}
