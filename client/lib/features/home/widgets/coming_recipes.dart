import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model/recipe/preview.dart' as rp_model;
import '../viewmodels/coming_recipes_viewmodel.dart';

class ComingRecipes extends StatelessWidget {
  const ComingRecipes({super.key});

  Widget _homeRecipePreview(
      rp_model.RecipePreview recipe, ComingRecipesViewModel viewModel) {
    return Column(
      children: <Widget>[
        RecipePreview(
          recipe: recipe,
          homepage: true,
          calendarEntry: viewModel.calendarEntries[recipe],
        ),
        const CustomDivider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ComingRecipesViewModel viewModel =
        Provider.of<ComingRecipesViewModel>(context);
    return switch (viewModel.state) {
      WidgetStates.idle => Container(),
      WidgetStates.loading => const CircularProgressIndicator(),
      WidgetStates.error => Text(AppLocalizations.of(context)!.error),
      WidgetStates.ready => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              viewModel.recipes.length,
              (int index) => _homeRecipePreview(
                  viewModel.recipes.elementAt(index), viewModel))),
      WidgetStates.dispose => const Text("dispose"),
    };
  }
}
