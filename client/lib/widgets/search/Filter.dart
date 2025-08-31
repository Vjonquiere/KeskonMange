import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_icons.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30),
      child: Row(
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
    );
  }
}
