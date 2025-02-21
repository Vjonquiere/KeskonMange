import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_icons.dart';

class Filter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.getIcon("toDoList"),
          width: 50,
          height: 50,
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
        Text(
          "Filter by",
          style: TextStyle(color: AppColors.blue, fontSize: 17),
        )
      ],
    );
  }
}
