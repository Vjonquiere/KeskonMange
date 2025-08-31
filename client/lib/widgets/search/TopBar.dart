import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.beige,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          //Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
          CircleAvatar(
            backgroundColor: AppColors.green,
            minRadius: 30,
            child: SvgPicture.asset(AppIcons.getIcon("search")),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          const Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
