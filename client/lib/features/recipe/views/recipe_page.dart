import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/widgets/recipe_card.dart';
import 'package:client/features/recipe/viewmodels/recipe_viewmodel.dart';
import 'package:client/features/recipe/widgets/ingredients_list.dart';
import 'package:client/features/recipe/widgets/steps_list.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/cooking_info.dart';
import '../../../core/widgets/custom_buttons.dart';

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
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RecipeCard(recipe: viewModel.recipe.recipePreview),
                ),
                CookingInfo(
                  recipe: "lasagne",
                ),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.list,
                      width: 48,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Originally made for x persons,"),
                        Text("Adapted for x")
                      ],
                    ),
                  ],
                ),
                IngredientsList(
                    expanded: viewModel.ingredientsExpanded,
                    ingredients: viewModel.recipe.ingredients),
                CustomButton(
                    text: viewModel.ingredientsExpanded
                        ? "Show less"
                        : "Show more",
                    onPressed: viewModel.switchIngredientsExpanded),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.prep,
                      width: 40,
                    ),
                    Expanded(child: StepsList(steps: viewModel.recipe.steps)),
                  ],
                )),
                /*CustomDivider(
                  color: AppColors.pink,
                  important: true,
                )*/
              ],
            ),
          )),
      WidgetStates.error => CircularProgressIndicator(),
      WidgetStates.dispose => CircularProgressIndicator(),
    };
  }
}
