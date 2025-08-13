import 'dart:math';

import 'package:client/custom_widgets/custom_buttons.dart';
import 'package:client/custom_widgets/ingredient_card.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientRow extends StatelessWidget {
  final List<IngredientCard> _ingredients;
  final bool _searchForIngredients;

  const IngredientRow(this._ingredients, this._searchForIngredients);

  @override
  Widget build(BuildContext context) {
    if (_ingredients.isEmpty && _searchForIngredients) {
      return noIngredientsFound();
    }
    List<Row> rows = [];
    bool isThreeRow = false;
    for (int i = 0; i < _ingredients.length;) {
      List<IngredientCard> currentRow = [];
      currentRow.addAll(_ingredients.getRange(
          i,
          isThreeRow
              ? min(i + 3, _ingredients.length)
              : min(i + 4, _ingredients.length)));
      rows.add(Row(
        children: currentRow,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
      i = i + (isThreeRow ? 3 : 4);
      isThreeRow = !isThreeRow;
    }

    return Column(children: rows);
  }

  Widget noIngredientsFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Ouch... It seems like no ingredient was found!"),
        CustomButton(
            text: "Add it!", onPressed: () => {}, color: AppColors.yellow)
      ],
    );
    return Center(
      child: Text("nothing found"),
    );
  }
}
