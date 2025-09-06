import 'dart:math';

import 'package:client/model/ingredient_quantity.dart';
import 'package:flutter/cupertino.dart';

import '../../recipe_creation/widgets/ingredient_review_card.dart';

class IngredientsList extends StatelessWidget {
  bool expanded;
  List<IngredientQuantity> ingredients;

  IngredientsList({required this.expanded, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Wrap(
          runAlignment: WrapAlignment.center,
          children: List<Padding>.generate(
            expanded ? ingredients.length : (min(3, ingredients.length)),
            (int index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: IngredientReviewCard(
                "test",
                "${ingredients[index].quantity} ${ingredients[index].unit.unit.toString().split(".").last}",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
