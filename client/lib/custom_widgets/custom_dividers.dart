import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  final bool important;

  const CustomDivider({
    this.color = AppColors.kaki,
    this.important = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (important) {
      return Divider(
        color: color,
        height: 40,
        thickness: 3,
        indent: 30,
        endIndent: 30,
      );
    } else {
      return Divider(
        color: color,
        height: 20,
        thickness: 1,
        indent: 20,
        endIndent: 20,
      );
    }
  }
}
