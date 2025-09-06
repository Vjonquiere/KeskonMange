import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/cooking_info.dart';
import 'package:client/features/recipe_creation/viewmodels/recipe_review_viewmodel.dart';
import 'package:client/features/recipe_creation/widgets/ingredient_review_card.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class RecipeReview extends StatelessWidget {
  const RecipeReview({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeReviewViewModel viewModel =
        Provider.of<RecipeReviewViewModel>(context);

    return switch (viewModel.state) {
      WidgetStates.idle => throw UnimplementedError(),
      WidgetStates.loading => CircularProgressIndicator(),
      WidgetStates.ready => Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  "Recipe name:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(viewModel.recipePreview.title),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card.filled(
                  color: AppColors.beige,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage(AppIcons.getIcon("placeholder")),
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                ),
                const CookingInfo(
                  recipe: "",
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(AppIcons.getIcon("list"), width: 48),
                Text("For ${viewModel.portions} persons:"),
              ],
            ),
            Wrap(
              runAlignment: WrapAlignment.center,
              children: List<Padding>.generate(
                viewModel.ingredients.length,
                (int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: IngredientReviewCard(
                    viewModel.ingredients.keys.elementAt(index).name,
                    "${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]?.quantity} ${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]?.unit.unit.toString().split(".").last}${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]!.quantity > 1 ? "s" : ""}",
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(AppIcons.getIcon("prep"), width: 48),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Column>.generate(
                      viewModel.steps.length,
                      (int index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Step $index: ${viewModel.steps[index].title}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.orange,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            viewModel.steps[index].stepText,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      WidgetStates.error => throw UnimplementedError(),
      WidgetStates.dispose => throw UnimplementedError(),
    };
  }
}
