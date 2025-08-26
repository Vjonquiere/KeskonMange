import 'package:client/core/ViewModel.dart';
import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';
import 'package:client/features/ingredient_creation/model/cereal_starches_category.dart';
import 'package:client/features/ingredient_creation/model/dairy_products_category.dart';
import 'package:client/features/ingredient_creation/model/drinks_category.dart';
import 'package:client/features/ingredient_creation/model/fat_category.dart';
import 'package:client/features/ingredient_creation/model/fruit_vegetable_category.dart';
import 'package:client/features/ingredient_creation/model/meat_category.dart';
import 'package:client/features/ingredient_creation/model/sweets_category.dart';

class IngredientCreationViewModel extends ViewModel {
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
}
