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
  List<DropdownMenuItem<Unit>> items = [];

  _IngredientQuantityState(this.ingredients) {
    currentIngredient = ingredients.first;
    selectedUnit = {ingredients.first.type.first};
    updateUnits();
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
                onPressed: previousIngredient, child: Text("previous")),
            Expanded(child: _getCard(currentIngredient)),
            OutlinedButton(onPressed: nextIngredient, child: Text("next")),
          ],
        ),
        SegmentedButton(
          segments: _getTypeSelection(currentIngredient),
          selected: selectedUnit,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedUnit = newSelection;
              updateUnits();
            });
          },
        ),
        _buildQuantitySelector(),
      ],
    );
  }

  void updateUnits() {
    items.clear();
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
    selectedDetailedUnit = items.first.value!;
  }

  void nextIngredient() {
    setState(() {
      if (currentIndex >= ingredients.length - 1) return;
      values[currentIngredient] = iq.IngredientQuantity(selectedUnit.first, 0);

      currentIndex++;
      currentIngredient = ingredients[currentIndex];
      if (values.containsKey(currentIngredient)) {
        selectedUnit = {values[currentIngredient]!.unit};
      } else {
        selectedUnit = {currentIngredient.type.first};
      }
      updateUnits();
    });
  }

  void previousIngredient() {
    setState(() {
      if (currentIndex <= 0) return;
      values[currentIngredient] = iq.IngredientQuantity(selectedUnit.first, 0);
      currentIndex--;
      currentIngredient = ingredients[currentIndex];
      if (values.containsKey(currentIngredient)) {
        selectedUnit = {values[currentIngredient]!.unit};
      } else {
        selectedUnit = {currentIngredient.type.first};
      }
      updateUnits();
    });
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              image: AssetImage(AppIcons.getIcon("placeholder")),
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
