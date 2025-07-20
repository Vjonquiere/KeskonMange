import 'dart:collection';

import 'package:client/custom_widgets/ingredient_card.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/ingredient_units.dart';
import 'package:client/model/ingredient_quantity.dart' as iq;
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/app_icons.dart';

class IngredientQuantity extends StatefulWidget {
  final List<Ingredient> _ingredients;

  const IngredientQuantity(this._ingredients, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _IngredientQuantityState(_ingredients);
  }
}

class _IngredientQuantityState extends State<IngredientQuantity> {
  HashMap<Ingredient, iq.IngredientQuantity> values = HashMap();
  List<Ingredient> ingredients;
  int currentIndex = 0;
  late Ingredient currentIngredient;
  late Set<Unit> selectedUnit;
  late Unit selectedDetailedUnit; // Used for precision unit

  _IngredientQuantityState(this.ingredients) {
    currentIngredient = ingredients.first;
    selectedUnit = {ingredients.first.type.first};
    selectedDetailedUnit = ingredients.first.type.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () => {
                      setState(() {
                        if (currentIndex <= 0) return;
                        values[currentIngredient] =
                            iq.IngredientQuantity(selectedUnit.first, 0);
                        currentIndex--;
                        currentIngredient = ingredients[currentIndex];
                        if (values.containsKey(currentIngredient)) {
                          selectedUnit = {values[currentIngredient]!.unit};
                        } else {
                          selectedUnit = {currentIngredient.type.first};
                        }
                      })
                    },
                child: Text("previous")),
            _getCard(currentIngredient),
            OutlinedButton(
                onPressed: () => {
                      setState(() {
                        values[currentIngredient] =
                            iq.IngredientQuantity(selectedUnit.first, 0);
                        if (currentIndex >= ingredients.length - 1) return;
                        currentIndex++;
                        currentIngredient = ingredients[currentIndex];
                        if (values.containsKey(currentIngredient)) {
                          selectedUnit = {values[currentIngredient]!.unit};
                        } else {
                          selectedUnit = {currentIngredient.type.first};
                        }
                      })
                    },
                child: Text("next")),
          ],
        ),
        SegmentedButton(
          segments: _getTypeSelection(currentIngredient),
          selected: selectedUnit,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedUnit = newSelection;
            });
          },
        ),
        _buildQuantitySelector(),
      ],
    );
  }

  List<ButtonSegment<Unit>> _getTypeSelection(Ingredient ingredient) {
    List<ButtonSegment<Unit>> types = [];
    for (Unit unit in ingredient.type) {
      types.add(ButtonSegment(value: unit, label: Text(unit.toString())));
    }
    return types;
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
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    List<DropdownMenuItem<Unit>> items = [];
    if (selectedUnit.first is VolumeUnit) {
      items.addAll(VolumeUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else if (selectedUnit.first is SpecialUnit) {
      items.addAll(SpecialUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else if (selectedUnit.first is WeightUnit) {
      items.addAll(WeightUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else if (selectedUnit.first is WholeUnit) {
      items.addAll(WholeItemsUnits.values.map((elt) => DropdownMenuItem(
          value: getUnitFromEnum(elt), child: Text(elt.name))));
    } else {
      throw Exception("");
    }
    setState(() {
      selectedDetailedUnit = items.first.value!;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("I need"),
        const SizedBox(
            width: 75,
            child: TextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
            )),
        DropdownButton(
            value: selectedDetailedUnit,
            iconEnabledColor: AppColors.green,
            items: items,
            onChanged: (newValue) {
              setState(() {
                selectedDetailedUnit = newValue!;
              });
              debugPrint(newValue.toString());
            }),
        Text("of ${currentIngredient.name}"),
      ],
    );
  }
}
