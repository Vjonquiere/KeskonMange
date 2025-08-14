import 'package:client/features/recipe_creation/viewmodels/ingredient_quantities_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ingredient.dart';
import '../../../model/ingredient_units.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';

class IngredientQuantities extends StatelessWidget {
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

  Widget _buildQuantitySelector(IngredientQuantitiesViewModel viewModel) {
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
            value: viewModel.selectedDetailedUnit,
            iconEnabledColor: AppColors.green,
            items: viewModel.items,
            onChanged: viewModel.updateDetailedSelectedUnit),
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: viewModel.previousIngredient,
                child: Text("previous")),
            Expanded(child: _getCard(viewModel.currentIngredient)),
            OutlinedButton(
                onPressed: viewModel.nextIngredient, child: Text("next")),
          ],
        ),
        SegmentedButton(
          segments: viewModel.getTypeSelection,
          selected: viewModel.selectedUnit,
          onSelectionChanged: viewModel.updateSelectedUnit,
        ),
        _buildQuantitySelector(viewModel),
      ],
    );
  }
}
