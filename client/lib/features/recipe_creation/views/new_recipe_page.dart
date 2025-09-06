import 'package:client/features/recipe_creation/viewmodels/ingredient_quantities_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/ingredients_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/recipe_review_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/recipe_step_viewmodel.dart';
import 'package:client/features/recipe_creation/views/general_information.dart';
import 'package:client/features/recipe_creation/views/recipe_review.dart';
import 'package:client/features/recipe_creation/views/recipe_steps_writing.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../user_creations/views/my_creations_page.dart';
import '../viewmodels/general_information_viewmodel.dart';
import '../viewmodels/new_recipe_viewmodel.dart';
import 'ingredient_quantities.dart';
import 'ingredients_selection.dart';

class NewRecipePage extends StatelessWidget {
  const NewRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NewRecipeViewModel viewModel =
        Provider.of<NewRecipeViewModel>(context);
    Widget content;
    switch (viewModel.currentStep) {
      case 0:
        content = ChangeNotifierProvider<GeneralInformationViewModel>.value(
          value:
              (viewModel.currentStepViewModel as GeneralInformationViewModel),
          child: const GeneralInformation(),
        );
        break;
      case 1:
        content = ChangeNotifierProvider<IngredientsViewModel>.value(
          value: (viewModel.currentStepViewModel as IngredientsViewModel),
          child: const IngredientSelection(),
        );
        break;
      case 2:
        content = ChangeNotifierProvider<IngredientQuantitiesViewModel>.value(
          value:
              (viewModel.currentStepViewModel as IngredientQuantitiesViewModel),
          child: const IngredientQuantities(),
        );
        break;
      case 3:
        content = ChangeNotifierProvider<RecipeStepViewModel>.value(
          value: (viewModel.currentStepViewModel as RecipeStepViewModel),
          child: const RecipeStepsWriting(),
        );
        break;
      case 4:
        content = ChangeNotifierProvider<RecipeReviewViewModel>.value(
          value: (viewModel.currentStepViewModel as RecipeReviewViewModel),
          child: const RecipeReview(),
        );
        break;
      default:
        content = const Center(child: Text("No more steps"));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: bottomButtons(context, viewModel),
      ),
      body: SafeArea(
        child: Column(
          //padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                ColorfulTextBuilder("Create your recipe!", 30, true)
                    .getWidget(),
              ],
            ),
            const SizedBox(height: 20.0),
            LinearPercentIndicator(
              percent: viewModel.progressBarValue,
              lineHeight: 25,
              backgroundColor: AppColors.beige,
              progressColor: AppColors.kaki,
              barRadius: const Radius.circular(25.0),
              center: Text("${(viewModel.progressBarValue * 100).round()}%"),
              animation: true,
              animationDuration: 1000,
              animateFromLastPercent: true,
              onAnimationEnd: () {},
            ),
            const SizedBox(height: 20),
            content,
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons(BuildContext context, NewRecipeViewModel viewModel) {
    if (viewModel.currentStep == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CustomButton(
            text: "GO BACK",
            onPressed: () {
              Navigator.of(context).pop(
                MaterialPageRoute<MyCreationsPage>(
                    builder: (BuildContext context) => const MyCreationsPage()),
              );
            },
          ),
          CustomButton(
            text: "NEXT",
            onPressed: viewModel.nextStep,
          ),
        ],
      );
    }
    if (viewModel.currentStep == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //TODO: add actions to buttons
        children: <Widget>[
          CustomButton(text: "MODIFY", onPressed: viewModel.previousStep),
          CustomButton(
            text: "PUBLISH",
            onPressed: () {},
            color: AppColors.pink,
          ),
          CustomButton(text: "DELETE", onPressed: () {}),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CustomButton(
          text: "PREVIOUS",
          onPressed: viewModel.previousStep,
        ),
        CustomButton(text: "NEXT", onPressed: viewModel.nextStep),
      ],
    );
  }
}
