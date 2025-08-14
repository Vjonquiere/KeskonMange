import 'package:client/features/recipe_creation/viewmodels/general_information_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_buttons.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../viewmodels/new_recipe_viewmodel.dart';

class GeneralInformation extends StatelessWidget {
  Padding questionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget numberOfPeopleFed(GeneralInformationViewModel viewModel) {
    return Column(
      children: [
        questionText("How many persons does it feed?"),
        Wrap(
          spacing: 10.0, // Space between radio buttons
          children: List.generate(10, (index) {
            int value = index + 1;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: value,
                  groupValue: viewModel.portions,
                  activeColor: AppColors.pink,
                  onChanged: viewModel.setPortions,
                ),
                Text(value.toString()),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget mealTypeRadioButton(
      GeneralInformationViewModel viewModel, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: viewModel.typeOfMeal,
          activeColor: AppColors.pink,
          onChanged: viewModel.setMealType,
        ),
        Text(value),
      ],
    );
  }

  Widget kindOfRecipe(GeneralInformationViewModel viewModel) {
    return Column(
      children: [
        questionText("What type of recipe is it?"),
        Wrap(
          spacing: 20.0,
          children: [
            mealTypeRadioButton(viewModel, "Starter"),
            mealTypeRadioButton(viewModel, "Main Course"),
            mealTypeRadioButton(viewModel, "Dessert"),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                mealTypeRadioButton(viewModel, "Other"),
                const Text("Other:"),
                const SizedBox(width: 10),
                SizedBox(
                  width: 120,
                  child: TextField(
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.yellow),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.pink),
                      ),
                    ),
                    onChanged: /*(value) {
                      setState(() {
                        _typeOfMeal = value;
                      });
                    }*/
                        (value) => {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  TextField userTextInput(String input, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: input,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.yellow), // Yellow underline
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.pink), // Orange when focused
        ),
      ),
    );
  }

  Widget cookingTime(GeneralInformationViewModel viewModel) {
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.getIcon("timer"),
          width: 48,
          height: 48,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Preparation time in minutes\t",
                    )),
                SizedBox(
                  width: 50,
                  child: userTextInput("", viewModel.preparationTimeController),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Cooking time in minutes\t",
                    )),
                SizedBox(
                  width: 50,
                  child: userTextInput("", viewModel.cookingTimeController),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget addRecipePicture(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText("What does it look like?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card.filled(
              color: AppColors.beige,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(AppIcons.getIcon("placeholder")),
                  width: imageWidth,
                ),
              ),
            ),
            Column(
              children: [
                CustomButton(
                    text: "Import", onPressed: () {}, color: AppColors.blue),
                CustomButton(
                    text: "Take a picture",
                    onPressed: () {},
                    color: AppColors.yellow),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final GeneralInformationViewModel viewModel =
        Provider.of<GeneralInformationViewModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        addRecipePicture(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            questionText("What do we cook?"),
            userTextInput("Recipe title", viewModel.recipeTitleController),
            const SizedBox(height: 16), // Add spacing
            numberOfPeopleFed(viewModel),
            kindOfRecipe(viewModel),
            cookingTime(viewModel),
          ],
        )
      ],
    );
  }
}
