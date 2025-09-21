import 'package:client/core/view_model.dart';
import 'package:client/model/ingredient.dart';

import '../../../../data/repositories/repositories_manager.dart';
import '../../../../data/usecases/ingredient/search_ingredient_by_name_use_case.dart';

class IngredientFilterViewModel extends ViewModel {
  final List<Ingredient> _selectedIngredients = <Ingredient>[];
  final List<Ingredient> _searchIngredients = <Ingredient>[];
  final SearchIngredientByNameUseCase _searchIngredientByNameUseCase =
      SearchIngredientByNameUseCase(
    RepositoriesManager().getIngredientRepository(),
  );

  IngredientFilterViewModel() {
    updateDisplayedIngredients();
  }

  List<Ingredient> get selectedIngredients => _selectedIngredients;
  List<Ingredient> get searchIngredients => _searchIngredients;

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

  void onIngredientSelectionChanged(Ingredient ingredient, bool value) {
    if (!value && selectedIngredients.contains(ingredient)) {
      selectedIngredients.remove(ingredient);
      updateDisplayedIngredients(name: _searchIngredientByNameUseCase.name);
    }
    if (value && !selectedIngredients.contains(ingredient)) {
      selectedIngredients.add(ingredient);
      if (searchIngredients.contains(ingredient)) {
        searchIngredients.remove(ingredient);
      }
    }
    notifyListeners();
  }
}
