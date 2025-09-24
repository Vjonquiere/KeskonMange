import 'package:client/core/view_model.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/ingredient.dart';

import '../../../../model/ingredient_quantity.dart';

class IngredientsListViewModel extends ViewModel {
  final List<IngredientQuantity> ingredients;
  bool expanded;
  bool showExpandedButton;
  List<String> names = [];

  IngredientsListViewModel(this.ingredients,
      {this.expanded = false, this.showExpandedButton = true}) {
    _fetchNames();
  }

  Future<void> _fetchNames() async {
    for (IngredientQuantity ingredient in ingredients) {
      names.add(await getNameFromRecipeId(ingredient.ingredientId));
    }
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Future<String> getNameFromRecipeId(int id) async {
    final Ingredient? ingredient = await RepositoriesManager()
        .getIngredientRepository()
        .getIngredientFromId(id);
    return ingredient == null ? "" : ingredient.name;
  }

  void onSwitchExpanded() {
    expanded = !expanded;
    notifyListeners();
  }
}
