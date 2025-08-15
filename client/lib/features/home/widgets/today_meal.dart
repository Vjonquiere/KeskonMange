import 'package:client/features/home/viewmodels/today_meal_viewmodel.dart';
import 'package:client/features/home/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/cooking_info.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../model/recipe/preview.dart';
import '../../../utils/app_colors.dart';

class TodayMeal extends StatelessWidget {
  Widget mainRecipes(BuildContext context, TodayMealViewModel viewModel) {
    return switch (viewModel.state) {
      WidgetStates.idle => Container(),
      WidgetStates.loading => const CircularProgressIndicator(),
      WidgetStates.error => Text("error"),
      WidgetStates.ready => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "previous",
                  onPressed: viewModel.previousRecipe,
                  color: AppColors.white,
                ),
                RecipeCard(recipe: viewModel.currentRecipe),
                CustomButton(
                  text: "next",
                  onPressed: viewModel.nextRecipe,
                  color: AppColors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(viewModel.radioButtonCount, (index) {
                return Radio<int>(
                  value: index,
                  groupValue: viewModel.currentRadioButton,
                  onChanged: viewModel.onRecipeChanged,
                  activeColor: AppColors.green,
                );
              }),
            )
          ],
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodayMealViewModel>(context);
    return Column(
      children: [
        ColorfulTextBuilder("Today", 35, true).getWidget(),
        mainRecipes(context, viewModel),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CookingInfo(
              recipe: "lasagne",
              iconName: "timer",
            ),
            CookingInfo(
              recipe: "lasagne",
              iconName: "bell",
            ),
          ],
        ),
        CustomButton(onPressed: () {}, text: "Let's go !")
      ],
    );
  }
}
