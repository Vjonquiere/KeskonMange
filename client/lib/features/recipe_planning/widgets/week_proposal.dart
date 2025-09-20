import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/features/home/widgets/recipe_preview.dart' as view;
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/meal_configuration.dart';

class WeekProposal extends StatelessWidget {
  final Map<MealConfiguration, RecipePreview> recipes;

  WeekProposal({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          final MealConfiguration currentMeal = recipes.keys.elementAt(index);
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(currentMeal.day
                          .translate(context)
                          .substring(0, 3)
                          .toUpperCase()),
                      Text(currentMeal.meal.name)
                    ],
                  ),
                  Expanded(
                      child: view.RecipePreview(
                    recipe: recipes[currentMeal]!,
                  )),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {},
                    color: AppColors.pink,
                  )
                ],
              ));
        });
  }
}
