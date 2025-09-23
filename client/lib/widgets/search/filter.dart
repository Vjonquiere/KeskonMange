import 'package:client/features/recipe_search/widgets/menu_filter_chip.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/recipe_search/model/filters.dart' as model;
import '../../utils/app_icons.dart';

class Filter extends StatelessWidget {
  Function(model.FilterType, model.Filter?) filterCallback;

  Filter(this.filterCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              SvgPicture.asset(
                AppIcons.getIcon("toDoList"),
                width: 40,
                height: 40,
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              const Text(
                "Filter by",
                style: TextStyle(color: AppColors.blue, fontSize: 17),
              ),
            ],
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 40),
              child: Flexible(
                  child: ListView.builder(
                itemCount: model.FilterType.values.length,
                itemBuilder: (BuildContext context, int index) {
                  return MenuFilterChip(
                    filterType: model.FilterType.values.elementAt(index),
                    addFilterCallback: filterCallback,
                    onFilterToggled: (model.FilterType t) {},
                  );
                },
                scrollDirection: Axis.horizontal,
              ))),
        ],
      ),
    );
  }
}
