import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_search/model/filters.dart';

class MealCourseFilter extends Filter {
  Set<MealCourse> courses;

  MealCourseFilter(this.courses);

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
