import 'package:client/features/recipe_creation/widgets/ingredient_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ingredient_row.dart';

class IngredientSelector extends StatelessWidget {
  final List<IngredientCard> selectedIngredients;
  final List<IngredientCard> searchIngredients;
  final TextEditingController controller;
  final Function(String) onSearchChanged;

  IngredientSelector(
      {required this.searchIngredients,
      required this.selectedIngredients,
      required this.controller,
      required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IngredientRow(selectedIngredients, false),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.search),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onSearchChanged,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: IngredientRow(searchIngredients, true),
          ),
        ),
      ],
    );
  }
}
