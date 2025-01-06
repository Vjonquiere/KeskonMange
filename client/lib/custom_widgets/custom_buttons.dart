import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;


  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color = AppColors.blue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var icons = AppIcons.getIcon(text) != 'Icon not found' ? true : false;
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
      ),
      // Put an icon if one is available
      icon: icons != false ? SvgPicture.asset(AppIcons.getIcon(text)) : const SizedBox.shrink(),
      label:icons != false ? const Text('') : Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),

    );
  }
}
