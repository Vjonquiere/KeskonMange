import 'package:client/custom_widgets/ingredient_card.dart';
import 'package:client/model/ingredient.dart';
import 'package:flutter/material.dart';

import '../utils/app_icons.dart';

class IngredientQuantity extends StatefulWidget {
  List<Ingredient> _ingredients;

  IngredientQuantity(this._ingredients, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _IngredientQuantityState();
  }
}

class _IngredientQuantityState extends State<IngredientQuantity> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
            onPressed: () => {
                  setState(() {
                    if (currentIndex <= 0) return;
                    currentIndex--;
                  })
                },
            child: Text("previous")),
        _getCard(widget._ingredients[currentIndex]),
        OutlinedButton(
            onPressed: () => {
                  setState(() {
                    if (currentIndex >= widget._ingredients.length - 1) return;
                    currentIndex++;
                  })
                },
            child: Text("next")),
      ],
    );
  }

  Widget _getCard(Ingredient ingredient) {
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              image: AssetImage(AppIcons.getIcon("placeholder")),
              width: 500,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [Text(ingredient.name)],
          ),
          _unitQuantitySelector()
        ],
      ),
    );
  }

  Widget _unitQuantitySelector() {
    return Row(
      children: [],
    );
  }

  Widget _volumeQuantitySelector() {
    return Row(
      children: [],
    );
  }

  Widget _weightQuantitySelector() {
    return Row(
      children: [
        TextField(
          keyboardType: TextInputType.number,
        )
      ],
    );
  }

  Widget _specialQuantitySelector() {
    return Row(
      children: [
        TextField(
          keyboardType: TextInputType.number,
        )
      ],
    );
  }
}
