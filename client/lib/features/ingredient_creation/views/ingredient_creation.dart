import 'package:client/core/widgets/allergens_selector.dart';
import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/features/ingredient_creation/viewmodels/ingredient_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
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

  Widget nameStep() {
    return Row(
      children: [
        boldText("How is it called ?"),
        const SizedBox(
          width: 20,
        ),
        const SizedBox(
          child: TextField(),
          width: 250,
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

  Widget allergensStep() {
    return Column(
      children: [
        boldText("Does it contain allergens ?"),
        AllergensSelector(
            selected: List.generate(allergens.length, (index) => false),
            onSelected: (index, boo) {})
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    IngredientCreationViewModel viewModel =
        Provider.of<IngredientCreationViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            ColorfulTextBuilder("Create new ingredient", 30, true).getWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(children: [
          nameStep(),
          specificationsStep(viewModel),
          categoryStep(viewModel),
          allergensStep()
        ]),
      ),
    );
  }
}
