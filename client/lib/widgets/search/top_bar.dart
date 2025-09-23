import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class TopBar extends StatelessWidget {
  Function(String) onSearchTextChanged;

  TopBar({super.key, required this.onSearchTextChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SearchBar(
          onChanged: onSearchTextChanged,
          leading: Padding(
            padding: EdgeInsetsGeometry.only(right: 15),
            child: CircleAvatar(
              backgroundColor: AppColors.green,
              minRadius: 30,
              child: SvgPicture.asset(AppIcons.getIcon("search")),
            ),
          ),
          hintText: "Search",
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0.0),
          side: WidgetStateProperty.all(BorderSide(
              style: BorderStyle.solid, color: AppColors.green, width: 2)),
          padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(0)),
        ));
  }
}
