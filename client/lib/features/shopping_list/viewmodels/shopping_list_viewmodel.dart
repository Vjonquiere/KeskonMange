import 'package:client/core/view_model.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/ingredient.dart';

class ShoppingListViewModel extends ViewModel {
  Map<Ingredient, List<IngredientQuantity>> ingredients = {};
  Map<Ingredient, bool> done = {};
  Set<int> selected = {};

  ShoppingListViewModel() {
    _getIngredients();
  }

  void onSelectionChanged(Set<int> value) {
    if (value.isEmpty) return;
    setStateValue(WidgetStates.loading);
    _getIngredients(to: DateTime.now().add(Duration(days: value.first)));
  }

  void _getIngredients({DateTime? to}) async {
    ingredients.clear();
    List<IngredientQuantity> ing = await RepositoriesManager()
        .getCalendarRepository()
        .getNeededIngredientsForDateRange(to: to);
    for (IngredientQuantity i in ing) {
      Ingredient? ingredient = await RepositoriesManager()
          .getIngredientRepository()
          .getIngredientFromId(i.ingredientId);
      if (ingredient != null) {
        if (!ingredients.containsKey(ingredient)) {
          ingredients[ingredient] = [];
        }
        bool found = false;
        for (IngredientQuantity ingQuant in ingredients[ingredient]!) {
          if (ingQuant.unit.unit == i.unit.unit) {
            found = true;
            ingQuant.quantity += i.quantity;
          }
        }
        if (!found) {
          ingredients[ingredient]?.add(i);
        }
      }
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  void onIngredientDoneSwitched(Ingredient ingredient, bool? value) {
    if (value == null) return;
    done[ingredient] = value;
    notifyListeners();
  }
}
