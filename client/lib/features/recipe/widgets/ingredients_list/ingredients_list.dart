import 'dart:math';

import 'package:client/features/recipe/widgets/ingredients_list/ingredients_list_viewmodel.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/widget_states.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../recipe_creation/widgets/ingredient_review_card.dart';

class IngredientsList extends StatelessWidget {
  final List<IngredientQuantity> ingredients;
  final bool expanded;
  final bool showExpandedButton;

  IngredientsList(
      {required this.ingredients,
      this.expanded = false,
      this.showExpandedButton = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => IngredientsListViewModel(ingredients,
          expanded: expanded, showExpandedButton: showExpandedButton),
      child: _IngredientsList(),
    );
  }
}

class _IngredientsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IngredientsListViewModel viewModel = Provider.of(context);
    if (viewModel.state == WidgetStates.idle) return Container();
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              runAlignment: WrapAlignment.center,
              children: List<Padding>.generate(
                viewModel.expanded
                    ? viewModel.ingredients.length
                    : (min(3, viewModel.ingredients.length)),
                (int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: IngredientReviewCard(
                    viewModel.names[index],
                    "${viewModel.ingredients[index].quantity} ${viewModel.ingredients[index].unit.unit.toString().split(".").last}",
                  ),
                ),
              ),
            ),
            CustomButton(
                text: viewModel.expanded ? "Show less" : "Show more",
                onPressed: viewModel.onSwitchExpanded),
          ],
        ),
      ),
    );
  }
}
