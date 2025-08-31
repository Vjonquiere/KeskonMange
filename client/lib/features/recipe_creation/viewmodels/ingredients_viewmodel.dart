import 'package:client/core/state_viewmodel.dart';
import 'package:client/model/ingredient.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/ingredient/search_ingredient_by_name_use_case.dart';
import '../../../utils/app_colors.dart';
import '../widgets/ingredient_card.dart';

class IngredientsViewModel extends StateViewModel {
  final List<Ingredient> _selectedIngredients = <Ingredient>[];
  final List<Ingredient> _searchIngredients = <Ingredient>[];
  final SearchIngredientByNameUseCase _searchIngredientByNameUseCase =
      SearchIngredientByNameUseCase(
    RepositoriesManager().getIngredientRepository(),
  );
  final TextEditingController _ingredientSearchController =
      TextEditingController();

  IngredientsViewModel() {
    updateDisplayedIngredients();
  }

  TextEditingController get ingredientSearchController =>
      _ingredientSearchController;

  void removeIngredient(Ingredient target) {
    _selectedIngredients
        .removeWhere((Ingredient ingredient) => ingredient.name == target.name);
    notifyListeners();
  }

  void addIngredient(Ingredient ingredient) {
    if (!_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.add(ingredient);
      _searchIngredients
          .removeWhere((Ingredient e) => e.name == ingredient.name);
      notifyListeners();
    }
  }

  List<IngredientCard> getSelectedIngredients() {
    final List<IngredientCard> ingredients = <IngredientCard>[];
    for (Ingredient ingredient in _selectedIngredients) {
      ingredients.add(
        IngredientCard(
          ingredient,
          () => <dynamic, dynamic>{},
          () => removeIngredient(ingredient),
          removable: true,
          backgroundColor: AppColors.blue,
        ),
      );
    }
    return ingredients;
  }

  List<IngredientCard> getSearchIngredients() {
    final List<IngredientCard> ingredients = <IngredientCard>[];
    for (Ingredient ingredient in _searchIngredients) {
      ingredients.add(
        IngredientCard(
          ingredient,
          () => addIngredient(ingredient),
          () => removeIngredient(ingredient),
        ),
      );
    }
    return ingredients;
  }

  List<Ingredient> getSelectedIngredientsClone() {
    return List.from(_selectedIngredients);
  }

  void updateDisplayedIngredients({String name = ""}) async {
    _searchIngredients.clear();
    _searchIngredientByNameUseCase.name = name;
    final List<Ingredient> result =
        await _searchIngredientByNameUseCase.execute();
    for (Ingredient e in result) {
      if (!_selectedIngredients.contains(e)) {
        _searchIngredients.add(e);
      }
    }
    notifyListeners();
  }

  void searchStringChanged(String ingredientName) {
    debugPrint(ingredientName);
    updateDisplayedIngredients(name: ingredientName);
  }

  @override
  Future<bool> isValid() async {
    return _selectedIngredients.isNotEmpty;
  }
}
