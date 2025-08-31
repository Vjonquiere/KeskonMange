import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../viewmodels/ingredients_viewmodel.dart';
import '../widgets/ingredient_row.dart';

class IngredientSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IngredientsViewModel viewModel =
        Provider.of<IngredientsViewModel>(context);
    return Column(
      children: [
        ColorfulTextBuilder("Add Ingredients", 25).getWidget(),
        IngredientRow(viewModel.getSelectedIngredients(), false),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                Expanded(
                    child: TextField(
                  controller: viewModel.ingredientSearchController,
                  onChanged: viewModel.searchStringChanged,
                ))
              ],
            )),
        IngredientRow(viewModel.getSearchIngredients(), true),
      ],
    );
  }

  /*List<Ingredient> ingredientsCardsToIngredients() {
    List<Ingredient> ingredients = [];
    for (IngredientCard current in _selectedIngredients) {
      ingredients.add(current.ingredient);
    }
    return ingredients;
  }*/
}
