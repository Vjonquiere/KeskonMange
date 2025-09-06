import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/recipe_creation/widgets/ingredient_selector.dart';
import 'package:client/features/recipe_planning/viewmodels/recipe_planning_viewmodel.dart';
import 'package:client/features/recipe_planning/widgets/weekly_planner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class RecipePlanningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecipePlanningViewModel viewModel =
        Provider.of<RecipePlanningViewModel>(context);
    return Scaffold(
        appBar: AppBar(
            title: ColorfulTextBuilder("Weekly planner", 25, true).getWidget()),
        body: SafeArea(
            child: Column(
          children: [
            Text(
              "Need meal for:",
              textAlign: TextAlign.start,
            ),
            Center(
              child: WeeklyPlanner(
                meals: viewModel.meals,
                onChanged: viewModel.onMealSlotValueChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: viewModel.keepValuesForNextTimes,
                    onChanged: viewModel.onKeepValuesForNextTimesChanged),
                Text("Keep those parameters for future planning"),
              ],
            ),
            CustomDivider(
              color: AppColors.pink,
              important: true,
            ),
            Text(
              "Add ingredients from my cupboard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: IngredientSelector(
              searchIngredients:
                  viewModel.ingredientsViewModel.getSearchIngredients(),
              selectedIngredients:
                  viewModel.ingredientsViewModel.getSelectedIngredients(),
              controller:
                  viewModel.ingredientsViewModel.ingredientSearchController,
              onSearchChanged:
                  viewModel.ingredientsViewModel.searchStringChanged,
            ))
          ],
        )));
  }
}
