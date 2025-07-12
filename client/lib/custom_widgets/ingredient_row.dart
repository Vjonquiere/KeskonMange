import 'dart:math';

import 'package:client/custom_widgets/ingredient_card.dart';
import 'package:flutter/cupertino.dart';

class IngredientRow extends StatelessWidget {
  final List<IngredientCard> _ingredients;

  const IngredientRow(this._ingredients);

  @override
  Widget build(BuildContext context) {
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
}
