import 'package:client/core/view_model.dart';
import 'package:client/features/recipe_planning/models/days.dart';

import '../../model/filters.dart';
import '../../model/meal_course_filter.dart';

class MealCourseFilterViewModel extends ViewModel {
  Set<MealCourse> _selected = {};

  bool isSelected(MealCourse course) {
    return _selected.contains(course);
  }

  void onSelectionSwitched(MealCourse course) {
    if (!_selected.remove(course)) {
      _selected.add(course);
    }
    notifyListeners();
  }

  Filter getFilter() {
    return MealCourseFilter(_selected);
  }
}
