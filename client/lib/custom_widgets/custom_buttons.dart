import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double scaleSize;
  final int fontSize;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color = AppColors.green,
    this.scaleSize = 0.5,
    this.fontSize = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var icons = AppIcons.getIcon(text) != 'Icon not found' ? true : false;
    if (icons == true) {
      return Transform.scale(
          scale: scaleSize,
          child: IconButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: const CircleBorder(),
            ),
            // Put an icon if one is available
            icon: SvgPicture.asset(AppIcons.getIcon(text)),
          ));
    }
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
