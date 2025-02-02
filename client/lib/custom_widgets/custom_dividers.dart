import 'package:flutter/material.dart';
import 'package:client/utils/app_colors.dart';

/// Creates horizontal dividers.
///
/// If the [important] is true, the divider is thick .
/// Else it is thin.
/// The color by default is kaki but customizable.
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
