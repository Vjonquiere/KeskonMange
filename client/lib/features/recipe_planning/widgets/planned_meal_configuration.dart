import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/core/widgets/number_picker.dart';
import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_planning/models/meal_configuration.dart';
import 'package:client/features/recipe_planning/viewmodels/recipe_selection_viewmodel.dart';
import 'package:client/features/recipe_planning/views/recipe_selection_page.dart';
import 'package:client/l10n/app_localizations.dart';
import 'package:client/model/recipe/specifications.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/model/recipe/preview.dart' as model;

class PlannedMealConfiguration extends StatelessWidget {
  final MealConfiguration meal;
  Function(bool?) onStarterSelectionSwitch;
  Function(bool?) onMainCourseSelectionSwitch;
  Function(bool?) onDessertSelectionSwitch;
  Function() increasePortions;
  Function() decreasePortions;
  Function(int) onCookingTimeChanged;
  Function(Set<FoodPreference>) onFoodPreferencesChanged;
  Function(Set<model.RecipePreview>) updateManuallySelectedRecipes;
  int mealToConfigure;
  int mealIndex;

  PlannedMealConfiguration(
      {required this.meal,
      required this.onStarterSelectionSwitch,
      required this.onMainCourseSelectionSwitch,
      required this.onDessertSelectionSwitch,
      required this.increasePortions,
      required this.decreasePortions,
      required this.onCookingTimeChanged,
      required this.onFoodPreferencesChanged,
      required this.mealToConfigure,
      required this.mealIndex,
      required this.updateManuallySelectedRecipes});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      spacing: 20,
      children: [
        Card(
          color: AppColors.beige,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text(
              "Meal $mealIndex/$mealToConfigure",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 25),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${meal.day.translate(context)} dd/mm"),
                Text("Meal")
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("City"),
                Row(
                  children: [
                    Text("20°"),
                    Icon(
                      Icons.sunny,
                      size: 16,
                      color: AppColors.yellow,
                    )
                  ],
                )
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColors.blue,
                        value: meal.courses.contains(MealCourse.starter),
                        onChanged: onStarterSelectionSwitch),
                    Text("Starter")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: meal.courses.contains(MealCourse.main),
                        onChanged: onMainCourseSelectionSwitch),
                    Text("Main Course")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColors.orange,
                        value: meal.courses.contains(MealCourse.dessert),
                        onChanged: onDessertSelectionSwitch),
                    Text("Dessert")
                  ],
                )
              ],
            ),
            Column(
              children: [
                Text("Will be"),
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: IconButton(
                          onPressed: decreasePortions,
                          icon: Icon(Icons.expand_less)),
                    ),
                    Text(
                      "${meal.portions}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue,
                          fontSize: 20),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: IconButton(
                          onPressed: increasePortions,
                          icon: Icon(Icons.expand_less)),
                    ),
                  ],
                ),
                Text("to eat"),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${meal.cookingTime}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                    fontSize: 20)),
            Text(" minutes to cook"),
            SizedBox(
              width: 15,
            ),
            NumberPicker(
              title: "Preparation time",
              buttonText: "Change",
              onValueChanged: onCookingTimeChanged,
              initialValue: meal.cookingTime,
              maxValue: 120,
            )
          ],
        ),
        SegmentedButton<FoodPreference>(
          segments: <ButtonSegment<FoodPreference>>[
            ButtonSegment<FoodPreference>(
                value: FoodPreference.vegetarian, label: Text("vegetarian")),
            ButtonSegment<FoodPreference>(
                value: FoodPreference.vegan, label: Text("vegan"))
          ],
          selected: meal.foodPreferences,
          onSelectionChanged: onFoodPreferencesChanged,
          emptySelectionAllowed: true,
          multiSelectionEnabled: true,
          selectedIcon: Icon(
            Icons.check,
            color: AppColors.blue,
          ),
        ),
        CustomDivider(
          color: AppColors.pink,
          important: true,
        ),
        Text("Choose your own recipe"),
        ChangeNotifierProvider(
          create: (_) => RecipeSelectionViewModel(
              updateManuallySelectedRecipes: updateManuallySelectedRecipes),
          child: RecipeSelectionPage(),
        ),
      ],
    ));
  }
}
