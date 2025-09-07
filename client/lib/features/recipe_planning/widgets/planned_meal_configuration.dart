import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/l10n/app_localizations.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlannedMealConfiguration extends StatelessWidget {
  final MealSlot day;

  PlannedMealConfiguration({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Center(
            child: Column(
          spacing: 20,
          children: [
            Card(
              color: AppColors.beige,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  "Meal x/x",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Day dd/mm"), Text("Meal")],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioGroup(
                        onChanged: (bool? o) {},
                        child: Row(
                          children: [
                            Checkbox(value: false, onChanged: (bool? o) {}),
                            Text("Starter")
                          ],
                        )),
                    RadioGroup(
                        onChanged: (bool? o) {},
                        child: Row(
                          children: [
                            Checkbox(value: false, onChanged: (bool? o) {}),
                            Text("Main Course")
                          ],
                        )),
                    RadioGroup(
                        onChanged: (bool? o) {},
                        child: Row(
                          children: [
                            Checkbox(value: false, onChanged: (bool? o) {}),
                            Text("Dessert")
                          ],
                        ))
                  ],
                ),
                Column(
                  children: [
                    Text("Will be"),
                    Row(
                      children: [
                        Icon(Icons.expand_less),
                        Text("x"),
                        Icon(Icons.expand_less),
                      ],
                    ),
                    Text("to eat"),
                  ],
                )
              ],
            )
          ],
        )));
  }
}
