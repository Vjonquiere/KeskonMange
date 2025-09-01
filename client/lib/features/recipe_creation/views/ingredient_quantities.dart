import 'package:client/features/recipe_creation/viewmodels/ingredient_quantities_viewmodel.dart';
import 'package:client/model/ingredient_units.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ingredient.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';

class IngredientQuantities extends StatelessWidget {
  const IngredientQuantities({super.key});

  Widget _getCard(Ingredient ingredient) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              image: AssetImage(AppIcons.getIcon("placeholder")),
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: <Widget>[Text(ingredient.name)],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(IngredientQuantitiesViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("I need"),
        SizedBox(
          width: 75,
          child: TextField(
            controller: viewModel.quantityController,
            maxLength: 4,
            keyboardType: TextInputType.number,
          ),
        ),
        DropdownButton<Unit>(
          value: viewModel.selectedDetailedUnit,
          iconEnabledColor: AppColors.green,
          items: viewModel.items,
          onChanged: viewModel.updateDetailedSelectedUnit,
        ),
        Text("of ${viewModel.currentIngredient.name}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final IngredientQuantitiesViewModel viewModel =
        Provider.of<IngredientQuantitiesViewModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: viewModel.previousIngredient,
              child: const Text("previous"),
            ),
            Expanded(child: _getCard(viewModel.currentIngredient)),
            OutlinedButton(
              onPressed: viewModel.nextIngredient,
              child: const Text("next"),
            ),
          ],
        ),
        SegmentedButton<UnitCategory>(
          segments: viewModel.getTypeSelection,
          selected: viewModel.selectedUnit,
          onSelectionChanged: viewModel.updateSelectedUnit,
        ),
        _buildQuantitySelector(viewModel),
      ],
    );
  }
}
