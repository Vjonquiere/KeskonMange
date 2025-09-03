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

class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecipeViewModel viewModel = Provider.of<RecipeViewModel>(context);
    return switch (viewModel.state) {
      WidgetStates.idle => CircularProgressIndicator(),
      WidgetStates.loading => CircularProgressIndicator(),
      WidgetStates.ready => Scaffold(
          body: Container(
            color: AppColors.white,
            child: Column(
              children: <Widget>[
                ColorfulTextBuilder(viewModel.recipe.recipePreview.title, 30)
                    .getWidget(),
                RecipeCard(recipe: viewModel.recipe.recipePreview),
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
                      width: 40,
                    ),
                    Column(
                      children: [],
                    )
                  ],
                ),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.prep,
                      width: 40,
                    ),
                    Column(
                      children: [],
                    )
                  ],
                ),
                CustomButton(
                  iconSize: 32,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: 'back',
                ),
              ],
            ),
          ),
        ),
      WidgetStates.error => CircularProgressIndicator(),
      WidgetStates.dispose => CircularProgressIndicator(),
    };
  }
}
