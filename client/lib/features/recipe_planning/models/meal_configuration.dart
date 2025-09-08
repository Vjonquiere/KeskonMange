import 'package:client/model/cloneable.dart';
import 'package:client/model/recipe/specifications.dart';

import 'days.dart';

class MealConfiguration implements Cloneable<MealConfiguration> {
  Day day;
  Meal meal;
  List<MealCourse> courses = <MealCourse>[MealCourse.main];
  int portions = 4;
  int cookingTime = 20;
  Set<FoodPreference> foodPreferences = <FoodPreference>{};

  MealConfiguration(this.day, this.meal);

  @override
  MealConfiguration clone() {
    final MealConfiguration clone = MealConfiguration(day, meal);
    clone.portions = portions;
    clone.courses =
        courses.toList(); // TODO: Check if toList is cloning the list
    clone.foodPreferences = foodPreferences.toSet();
    clone.cookingTime = cookingTime;
    return clone;
  }
}
