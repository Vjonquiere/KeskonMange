import 'package:client/features/recipe_creation/widgets/ingredient_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../viewmodels/ingredients_viewmodel.dart';
import '../widgets/ingredient_row.dart';

class IngredientSelection extends StatelessWidget {
  const IngredientSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final IngredientsViewModel viewModel =
        Provider.of<IngredientsViewModel>(context);
    return Column(
      children: <Widget>[
        ColorfulTextBuilder("Add Ingredients", 25).getWidget(),
        Expanded(
            child: IngredientSelector(
          selectedIngredients: viewModel.getSelectedIngredients(),
          searchIngredients: viewModel.getSearchIngredients(),
          controller: viewModel.ingredientSearchController,
          onSearchChanged: viewModel.searchStringChanged,
        ))
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
