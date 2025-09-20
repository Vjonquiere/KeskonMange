import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/recipe_search/model/filters.dart';
import '../../utils/app_icons.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

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
                itemCount: Filters.values.length,
                itemBuilder: (BuildContext context, int index) {
                  return InputChip(
                      label: Text(Filters.values.elementAt(index).toString()));
                },
                scrollDirection: Axis.horizontal,
              ))),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 40),
              child: Flexible(
                  child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return InputChip(label: Text(index.toString()));
                },
                scrollDirection: Axis.horizontal,
              ))),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          ),
        ],
      ),
    );
  }
}
