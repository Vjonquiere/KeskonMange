import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter_svg/svg.dart';

class CookingInfo extends StatelessWidget {
  final String recipe;
  final String iconName;
  //final Color color;
  //final double scaleSize;

  const CookingInfo({
    required this.recipe,
    this.iconName = "timer",
    //this.color = AppColors.green,
    //this.scaleSize = 0.5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (iconName) {
      case "timer":
        return Row(
          children: [
            SvgPicture.asset(
              AppIcons.getIcon("timer"),
              width: 32,
              height: 32,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Preparation time"),
                Text("cooking time"),
              ],
            ),
          ],
        );

      case "bell":
        return Row(
          children: [
            SvgPicture.asset(
              AppIcons.getIcon("bell"),
              width: 32,
              height: 32,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Meal at 20h30"),
                Text("Start cooking in 50min "),
              ],
            ),
          ],
        );
      default:
        {
          return const Text("Unimplemented widget");
        }
    }
  }
}
