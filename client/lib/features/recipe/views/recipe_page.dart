import 'package:client/model/recipe/preview.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';

class RecipePage extends StatefulWidget {
  final RecipePreview recipe;

  const RecipePage({super.key, required this.recipe});
  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white, // Set the background color
      child: Column(
        children: [
          ColorfulTextBuilder(widget.recipe.title, 30).getWidget(),
          const Placeholder(color: AppColors.green),
          CustomButton(
            iconSize: 32,
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'back',
          ),
        ],
      ),
    );
  }
}
