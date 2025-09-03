import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/widgets/recipe_card.dart';
import 'package:client/features/recipe/viewmodels/recipe_viewmodel.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/step.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/cooking_info.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../model/recipe/recipe.dart';
import '../../recipe_creation/widgets/ingredient_review_card.dart';

class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecipeViewModel viewModel = Provider.of<RecipeViewModel>(context);
    return switch (viewModel.state) {
      WidgetStates.idle => CircularProgressIndicator(),
      WidgetStates.loading => CircularProgressIndicator(),
      WidgetStates.ready => Scaffold(
          floatingActionButton: CustomButton(
            iconSize: 32,
            text: "back",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RecipeCard(recipe: viewModel.recipe.recipePreview),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CookingInfo(
                    recipe: "lasagne",
                  ),
                ),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        AppIcons.list,
                        width: 48,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Originally made for x persons,"),
                          Text("Adapted for x")
                        ],
                      ),
                    ],
                  ),
                ),
                Wrap(
                  runAlignment: WrapAlignment.center,
                  children: List<Padding>.generate(
                    viewModel.recipe.ingredients.length,
                    (int index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: IngredientReviewCard(
                        "test",
                        "${viewModel.recipe.ingredients[index].quantity} ${viewModel.recipe.ingredients[index].unit.unit.toString().split(".").last}",
                      ),
                    ),
                  ),
                ),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(
                          AppIcons.prep,
                          width: 40,
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Column>.generate(
                          viewModel.recipe.steps.length,
                          (int index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Step $index: ${viewModel.recipe.steps[index].title}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.orange,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                viewModel.recipe.steps[index].stepText,
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
          )),
      WidgetStates.error => CircularProgressIndicator(),
      WidgetStates.dispose => CircularProgressIndicator(),
    };
  }
}
