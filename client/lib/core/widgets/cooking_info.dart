import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter_svg/svg.dart';

import '../../l10n/app_localizations.dart';

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: link this to the next recipe
                Text(AppLocalizations.of(context)!.preparation_time(10)),
                Text(AppLocalizations.of(context)!.cooking_time(15)),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.planning_meal_time(
                    const TimeOfDay(hour: 20, minute: 30).format(context))),
                Text(AppLocalizations.of(context)!.planning_start_cooking(50)),
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
