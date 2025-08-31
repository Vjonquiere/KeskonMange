import 'package:client/features/home/viewmodels/today_meal_viewmodel.dart';
import 'package:client/features/home/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/cooking_info.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors.dart';

class TodayMeal extends StatelessWidget {
  const TodayMeal({super.key});

  Widget mainRecipes(BuildContext context, TodayMealViewModel viewModel) {
    return switch (viewModel.state) {
      WidgetStates.idle => Container(),
      WidgetStates.loading => const CircularProgressIndicator(),
      WidgetStates.error => Text(AppLocalizations.of(context)!.error),
      WidgetStates.dispose => const Text("dispose"),
      WidgetStates.ready => Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
              children: List.generate(viewModel.radioButtonCount, (int index) {
                return Radio<int>(
                  value: index,
                  groupValue: viewModel.currentRadioButton,
                  onChanged: viewModel.onRecipeChanged,
                  activeColor: AppColors.green,
                );
              }),
            ),
          ],
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final TodayMealViewModel viewModel =
        Provider.of<TodayMealViewModel>(context);
    return Column(
      children: <Widget>[
        ColorfulTextBuilder(AppLocalizations.of(context)!.today, 35, true)
            .getWidget(),
        mainRecipes(context, viewModel),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CookingInfo(
              recipe: "lasagne",
            ),
            CookingInfo(
              recipe: "lasagne",
              iconName: "bell",
            ),
          ],
        ),
        CustomButton(
          onPressed: () {},
          text: AppLocalizations.of(context)!.letsgo,
        ),
      ],
    );
  }
}
