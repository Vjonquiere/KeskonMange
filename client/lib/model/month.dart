import 'dart:ffi';

import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlannedRecipe {
  String date;
  int recipeId;
  int done;
  String resultImage;

  PlannedRecipe(this.date, this.recipeId, this.done, this.resultImage);

  factory PlannedRecipe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "date": String date,
        "recipeId": int recipeId,
        "done": int done,
        "result_img": String resultImage,
      } =>
        PlannedRecipe(date, recipeId, done, resultImage),
      _ => throw const FormatException('Failed to load PlannedRecipe.'),
    };
  }

  int getDay() {
    return int.parse(date.split("-")[2]);
  }
}

class Month {
  int year;
  int month;
  List<PlannedRecipe> plannedRecipes;
  List<List<int>> monthTemplate;
  final List<String> days = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];

  Month(this.year, this.month, this.plannedRecipes, this.monthTemplate);

  factory Month.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "year": int year,
        "month": int month,
        "recipes": List recipesJson,
        "monthTemplate": List monthTemplateJson,
      } =>
        Month(
          year,
          month,
          recipesJson
              .map((recipe) =>
                  PlannedRecipe.fromJson(recipe as Map<String, dynamic>))
              .toList(),
          monthTemplateJson.map((e) => List<int>.from(e as List)).toList(),
        ),
      _ => throw const FormatException('Failed to load Month.'),
    };
  }

  List<Widget> build(BuildContext context) {
    List<Widget> cols = [];
    for (int i = 0; i < monthTemplate[0].length; i++) {
      cols.add(Column(
        children: _buildWeek(i),
      ));
      cols.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)));
    }
    return cols;
  }

  List<Widget> _buildWeek(int index) {
    List<Widget> w = [];
    w.add(Text(
      days[index],
      style: const TextStyle(color: AppColors.green, fontSize: 20),
    ));
    for (List<int> week in monthTemplate) {
      if (week[index] == 0) {
        w.add(const SizedBox(
          width: 45,
          height: 66,
        ));
      } else {
        int d =
            plannedRecipes.indexWhere((item) => item.getDay() == week[index]);
        w.add(_buildDay(week[index], d != -1));
      }
    }
    return w;
  }

  Container _buildDay(int day, bool done) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.yellow, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          alignment: Alignment.center,
          width: 30,
          height: 50,
          color: AppColors.beige,
          child: done == false
              ? const SizedBox.shrink()
              : ClipOval(
                  child: Container(
                    width: 25,
                    height: 25,
                    color: AppColors.yellow,
                    child: Center(
                        child: Text("$day",
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12),
                            textAlign: TextAlign.center)),
                  ),
                ),
        ),
      ),
    );
  }
}
