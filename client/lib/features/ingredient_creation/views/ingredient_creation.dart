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
  Widget nameStep() {
    return const Row(
      children: [
        Text(
          "How is it called ?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          child: TextField(),
          width: 250,
        ),
      ],
    );
  }

  Widget ingredientType() {
    return Column();
  }

  Widget specificationsStep() {
    return Row(
      children: [
        Text(
          "Is it ?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.left,
        ),
        SegmentedButton(
          segments: [
            ButtonSegment(
                value: "vegetarian",
                label: Text("vegetarian"),
                icon: Icon(Icons.accessibility_new_rounded)),
            ButtonSegment(
                value: "vegan",
                label: Text("vegan"),
                icon: Icon(Icons.accessibility_new_rounded))
          ],
          selected: {},
          emptySelectionAllowed: true,
        )
      ],
    );
  }

  Widget allergensStep() {
    return Column(
      children: [
        const Text(
          "Does it contain allergens ?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.left,
        ),
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
        child: Column(
            children: [nameStep(), specificationsStep(), allergensStep()]),
      ),
    );
  }
}
