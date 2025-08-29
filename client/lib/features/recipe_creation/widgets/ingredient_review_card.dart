import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientReviewCard extends StatelessWidget {
  final String _ingredientName;
  final String _ingredientQuantity;

  IngredientReviewCard(this._ingredientName, this._ingredientQuantity,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.green,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: Column(
          children: [
            Text(
              _ingredientName,
              style: TextStyle(fontSize: 17),
            ),
            Text(_ingredientQuantity)
          ],
        ),
      ),
    );
  }
}
