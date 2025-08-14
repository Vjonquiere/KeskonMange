import 'package:client/features/recipe_creation/viewmodels/recipe_step_viewmodel.dart';
import 'package:client/features/recipe_creation/views/recipe_step_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_buttons.dart';

import '../../../model/recipe/step.dart' as st;
import '../widgets/step.dart';

class RecipeStepsWriting extends StatelessWidget {
  void addStep(BuildContext context, RecipeStepViewModel viewModel) async {
    st.Step? stepValue = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RecipeStepPage()));
    if (stepValue != null) {
      debugPrint(stepValue.toString());
      viewModel.addStep(stepValue);
    }
  }

  List<StepWidget> _generateSteps(RecipeStepViewModel viewModel) {
    return List.generate(
      viewModel.steps.length,
      (index) => StepWidget(
        viewModel.steps[index],
        stepNumber: index + 1,
        key: Key("${index + 1}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RecipeStepViewModel viewModel =
        Provider.of<RecipeStepViewModel>(context);
    return ReorderableListView(
      footer: CustomButton(
        text: "add",
        onPressed: () => addStep(context, viewModel),
        scaleSize: 1.0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      onReorder: viewModel.reorderSteps,
      children: _generateSteps(viewModel),
    );
  }
}
