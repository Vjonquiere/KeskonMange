import 'package:client/core/widgets/allergens_selector.dart';
import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/features/ingredient_creation/viewmodels/ingredient_viewmodel.dart';
import 'package:client/model/ingredient_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../core/widget_states.dart';
import '../../../utils/app_icons.dart';

class IngredientCreation extends StatelessWidget {
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
      children: [
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
      children: [
        boldText("Which category?"),
        Wrap(
          children: [
            SegmentedButton(
                segments: List.generate(
                    viewModel.categoriesCount,
                    (int index) => ButtonSegment(
                        value: viewModel.categories[index].toString(),
                        label: Text(viewModel.categories[index].toString()))),
                onSelectionChanged: viewModel.updateSelectedCategory,
                selected: viewModel.selectedCategoryString),
          ],
        ),
        ToggleButtons(
            isSelected: List.generate(
                viewModel.selectedCategory.getSubCategories().length,
                (int index) => viewModel.selectedSubCategories[index]),
            onPressed: viewModel.updateSelectedSubCategory,
            children: List.generate(
                viewModel.selectedCategory.getSubCategories().length,
                (int index) =>
                    Text(viewModel.selectedCategory.getSubCategories()[index])))
      ],
    );
  }

  Widget specificationsStep(IngredientCreationViewModel viewModel) {
    return Row(
      children: [
        boldText("Is it ?"),
        SegmentedButton(
          segments: List.generate(
              viewModel.specificationsCount,
              (int index) => ButtonSegment(
                  value: viewModel.specifications[index],
                  label: Text(viewModel.specifications[index]))),
          selected: viewModel.selectedSpecifications,
          onSelectionChanged: viewModel.updateSelectedSpecifications,
          emptySelectionAllowed: true,
          multiSelectionEnabled: true,
        )
      ],
    );
  }

  Widget unitStep(IngredientCreationViewModel viewModel) {
    return Column(
      children: [
        boldText("Which unit to measure this ingredient ?"),
        SegmentedButton(
          segments: List.generate(
              units.length,
              (int index) => ButtonSegment(
                  value: units.values.elementAt(index).toString(),
                  label: Text(units.values.elementAt(index).toString()))),
          selected: viewModel.selectedUnits,
          emptySelectionAllowed: false,
          multiSelectionEnabled: true,
          onSelectionChanged: viewModel.updateSelectedUnits,
        )
      ],
    );
  }

  Widget allergensStep(IngredientCreationViewModel viewModel) {
    return Column(
      children: [
        boldText("Does it contain allergens ?"),
        AllergensSelector(
            selected: viewModel.allergensValues,
            onSelected: viewModel.switchSelectedAllergen)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    IngredientCreationViewModel viewModel =
        Provider.of<IngredientCreationViewModel>(context);
    if (viewModel.state == WidgetStates.dispose) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title:
            ColorfulTextBuilder("Create new ingredient", 30, true).getWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(children: [
          nameStep(viewModel),
          specificationsStep(viewModel),
          categoryStep(viewModel),
          unitStep(viewModel),
          allergensStep(viewModel),
          ElevatedButton(
              onPressed: viewModel.pushIngredient,
              child: Text("Create ingredient !"))
        ]),
      ),
    );
  }
}
