import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

class IngredientReviewCard extends StatelessWidget {
  final String _ingredientName;
  final String _ingredientQuantity;

  const IngredientReviewCard(
    this._ingredientName,
    this._ingredientQuantity, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: Column(
          children: <Widget>[
            Text(
              _ingredientName,
              style: const TextStyle(fontSize: 15),
            ),
            Text(_ingredientQuantity, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
