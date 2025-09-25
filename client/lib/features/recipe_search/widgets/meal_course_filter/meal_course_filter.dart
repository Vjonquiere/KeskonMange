import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/features/recipe_search/widgets/meal_course_filter/meal_course_filter_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealCourseFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MealCourseFilterViewModel(),
      child: _MealCourseFilter(),
    );
  }
}

class _MealCourseFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MealCourseFilterViewModel viewModel = Provider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Select meal type"),
        Flexible(
            child: Wrap(
                children: List.generate(
          MealCourse.values.length,
          (int index) => InputChip(
            selected: viewModel.isSelected(MealCourse.values.elementAt(index)),
            label: Text(MealCourse.values.elementAt(index).name),
            onSelected: (bool value) {
              viewModel.onSelectionSwitched(MealCourse.values.elementAt(index));
            },
          ),
        ))),
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(viewModel.getFilter());
            },
            child: Text('Apply'))
      ],
    );
  }
}
