import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class WeeklyPlanner extends StatelessWidget {
  final List<MealSlot> meals;
  final void Function(int index, bool value) onChanged;

  WeeklyPlanner({required this.meals, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.beige,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
            spacing: 0,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Column>.generate(8, (int index) {
              index--;
              if (index < 0) {
                return Column(
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          color: AppColors.kaki, fontWeight: FontWeight.bold),
                    ),
                    Tooltip(
                        child: Icon(
                          Icons.sunny,
                          color: AppColors.yellow,
                        ),
                        message: AppLocalizations.of(context)!.lunch),
                    SizedBox(
                      height: 20,
                    ),
                    Tooltip(
                      child: Icon(
                        Icons.nightlight,
                        color: AppColors.blue,
                      ),
                      message: AppLocalizations.of(context)!.dinner,
                    ),
                  ],
                );
              }
              return Column(
                children: <Widget>[
                  Text(
                    meals[index * 2]
                        .day
                        .translate(context)
                        .substring(0, 3)
                        .toUpperCase(),
                    style: TextStyle(
                        color: AppColors.kaki, fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                      value: meals[index * 2].selected,
                      onChanged: (bool? value) {
                        onChanged(index * 2, value!);
                      }),
                  //Text(AppLocalizations.of(context)!.lunch, style: TextStyle(fontSize: 8),),
                  Checkbox(
                      value: meals[index * 2 + 1].selected,
                      onChanged: (bool? value) {
                        onChanged(index * 2 + 1, value!);
                      }),
                  //Text(AppLocalizations.of(context)!.dinner, style: TextStyle(fontSize: 8))
                ],
              );
            })),
      ),
    );
  }
}
