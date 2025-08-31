import 'package:client/core/widgets/allergens_selector.dart';
import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/features/ingredient_creation/viewmodels/ingredient_viewmodel.dart';
import 'package:client/model/ingredient_units.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';

class IngredientCreation extends StatelessWidget {
  const IngredientCreation({super.key});

  Widget boldText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget nameStep(IngredientCreationViewModel viewModel) {
    return Row(
      children: <Widget>[
        boldText("How is it called ?"),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 250,
          child: TextField(
            controller: viewModel.nameController,
          ),
        ),
      ],
    );
  }

  Widget categoryStep(IngredientCreationViewModel viewModel) {
    return Column(
      children: <Widget>[
        boldText("Which category?"),
        Wrap(
          children: <Widget>[
            SegmentedButton(
              segments: List.generate(
                viewModel.categoriesCount,
                (int index) => ButtonSegment(
                  value: viewModel.categories[index].toString(),
                  label: Text(viewModel.categories[index].toString()),
                ),
              ),
              onSelectionChanged: viewModel.updateSelectedCategory,
              selected: viewModel.selectedCategoryString,
            ),
          ],
        ),
        ToggleButtons(
          isSelected: List.generate(
            viewModel.selectedCategory.getSubCategories().length,
            (int index) => viewModel.selectedSubCategories[index],
          ),
          onPressed: viewModel.updateSelectedSubCategory,
          children: List.generate(
            viewModel.selectedCategory.getSubCategories().length,
            (int index) =>
                Text(viewModel.selectedCategory.getSubCategories()[index]),
          ),
        ),
      ],
    );
  }

  Widget specificationsStep(IngredientCreationViewModel viewModel) {
    return Row(
      children: <Widget>[
        boldText("Is it ?"),
        SegmentedButton(
          segments: List.generate(
            viewModel.specificationsCount,
            (int index) => ButtonSegment(
              value: viewModel.specifications[index],
              label: Text(viewModel.specifications[index]),
            ),
          ),
          selected: viewModel.selectedSpecifications,
          onSelectionChanged: viewModel.updateSelectedSpecifications,
          emptySelectionAllowed: true,
          multiSelectionEnabled: true,
        ),
      ],
    );
  }

  Widget unitStep(IngredientCreationViewModel viewModel) {
    return Column(
      children: <Widget>[
        boldText("Which unit to measure this ingredient ?"),
        SegmentedButton(
          segments: List.generate(
            units.length,
            (int index) => ButtonSegment(
              value: units.values.elementAt(index).toString(),
              label: Text(units.values.elementAt(index).toString()),
            ),
          ),
          selected: viewModel.selectedUnits,
          multiSelectionEnabled: true,
          onSelectionChanged: viewModel.updateSelectedUnits,
        ),
      ],
    );
  }

  Widget allergensStep(IngredientCreationViewModel viewModel) {
    return Column(
      children: <Widget>[
        boldText("Does it contain allergens ?"),
        AllergensSelector(
          selected: viewModel.allergensValues,
          onSelected: viewModel.switchSelectedAllergen,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final IngredientCreationViewModel viewModel =
        Provider.of<IngredientCreationViewModel>(context);
    if (viewModel.state == WidgetStates.dispose) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }

    if (viewModel.state == WidgetStates.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${viewModel.errorMessage!}"),
            duration: const Duration(seconds: 5),
            showCloseIcon: true,
          ),
        );
        viewModel.clearError();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title:
            ColorfulTextBuilder("Create new ingredient", 30, true).getWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: <Widget>[
            nameStep(viewModel),
            specificationsStep(viewModel),
            categoryStep(viewModel),
            unitStep(viewModel),
            allergensStep(viewModel),
            ElevatedButton(
              onPressed: viewModel.pushIngredient,
              child: const Text("Create ingredient !"),
            ),
          ],
        ),
      ),
    );
  }
}
