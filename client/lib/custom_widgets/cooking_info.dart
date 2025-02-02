import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter_svg/svg.dart';

/// Display some information about the next planned recipe.
///
/// If we ask for "timer" in [iconName], the widget
/// displays the cooking and preparation time needed for the recipe.
/// If we ask for "bell", the widget indicates when to start cooking to
/// eat the meal at the given time.
/// If any other [iconName] is given, return a text widget
/// indicating that the widget is not implemented
class CookingInfo extends StatelessWidget {
  final String recipe;
  final String iconName;

  const CookingInfo({
    required this.recipe,
    this.iconName = "timer",
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
