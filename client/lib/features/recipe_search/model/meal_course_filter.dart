import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_search/model/filters.dart';

class MealCourseFilter extends Filter {
  MealCourse course;

  MealCourseFilter(this.course);

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
