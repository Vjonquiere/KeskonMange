import 'package:client/features/recipe_search/widgets/ingredient_filter/ingredient_filter_view_model.dart';
import 'package:client/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:client/features/recipe_search/model/ingredient_filter.dart'
    as model;
import 'package:provider/provider.dart';

class IngredientFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => IngredientFilterViewModel(),
        child: _IngredientFilter());
  }
}

class _IngredientFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IngredientFilterViewModel viewModel =
        Provider.of<IngredientFilterViewModel>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Select Ingredients"),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40),
            child: Flexible(
                child: ListView.builder(
              itemCount: viewModel.searchIngredients.length +
                  viewModel.selectedIngredients.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < viewModel.selectedIngredients.length) {
                  final Ingredient ingredient =
                      viewModel.selectedIngredients.elementAt(index);
                  return InputChip(
                    label: Text(ingredient.name),
                    selected: true,
                    onSelected: (bool value) {
                      viewModel.onIngredientSelectionChanged(ingredient, value);
                    },
                  );
                } else {
                  final Ingredient ingredient = viewModel.searchIngredients
                      .elementAt(index - viewModel.selectedIngredients.length);
                  return InputChip(
                    label: Text(ingredient.name),
                    selected:
                        viewModel.selectedIngredients.contains(ingredient),
                    onSelected: (bool value) {
                      viewModel.onIngredientSelectionChanged(ingredient, value);
                    },
                  );
                }
              },
              scrollDirection: Axis.horizontal,
            ))),
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
          onChanged: (String? value) {
            if (value != null)
              viewModel.updateDisplayedIngredients(name: value);
          },
        ),
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(model.IngredientFilter(
                  ingredients: viewModel.selectedIngredients));
            },
            child: Text("close"))
      ],
    );
  }
}
