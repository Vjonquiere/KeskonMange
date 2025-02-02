import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

/// Creates buttons based on the text.
/// If an icon is available for it in [AppIcons],
/// we have an [IconButton].
/// Else, we have a [FilledButton] with the corresponding text.
/// By default the button is green.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double scaleSize; // for icons

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color = AppColors.green,
    this.scaleSize = 0.5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var icons = AppIcons.getIcon(text) != 'Icon not found' ? true : false;
    if (icons == true) {
      // Put an icon if one is available
      return Transform.scale(
          scale: scaleSize,
          child: IconButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: const CircleBorder(),
            ),
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
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
