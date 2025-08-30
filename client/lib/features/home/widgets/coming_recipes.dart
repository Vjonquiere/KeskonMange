import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model/recipe/preview.dart' as rpModel;
import '../viewmodels/coming_recipes_viewmodel.dart';

class ComingRecipes extends StatelessWidget {
  Widget _homeRecipePreview(rpModel.RecipePreview recipe) {
    return Column(
      children: [
        RecipePreview(
          recipe: recipe,
          homepage: true,
        ),
        const CustomDivider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ComingRecipesViewModel>(context);
    return switch (viewModel.state) {
      WidgetStates.idle => Container(),
      WidgetStates.loading => const CircularProgressIndicator(),
      WidgetStates.error => Text(AppLocalizations.of(context)!.error),
      WidgetStates.ready => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: viewModel.recipes
              .map((recipe) => _homeRecipePreview(recipe))
              .toList()),
      WidgetStates.dispose => Text("dispose"),
    };
  }
}
