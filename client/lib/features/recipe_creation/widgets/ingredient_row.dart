import 'dart:math';

import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/features/ingredient_creation/viewmodels/ingredient_viewmodel.dart';
import 'package:client/features/ingredient_creation/views/ingredient_creation.dart';
import 'package:client/features/recipe_creation/widgets/ingredient_card.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientRow extends StatelessWidget {
  final List<IngredientCard> _ingredients;
  final bool _searchForIngredients;

  const IngredientRow(this._ingredients, this._searchForIngredients,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (_ingredients.isEmpty && _searchForIngredients) {
      return noIngredientsFound(context);
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: _ingredients,
    );
  }

  Widget noIngredientsFound(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Ouch... It seems like no ingredient was found!"),
        CustomButton(
          text: "Add it!",
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<IngredientCreation>(
              builder: (BuildContext context) =>
                  ChangeNotifierProvider<IngredientCreationViewModel>(
                create: (BuildContext context) => IngredientCreationViewModel(),
                child: const IngredientCreation(),
              ),
            ),
          ),
          color: AppColors.yellow,
        ),
      ],
    );
  }
}
