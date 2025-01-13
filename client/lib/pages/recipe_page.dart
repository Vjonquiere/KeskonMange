import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/custom_buttons.dart';
import 'home_page.dart';

class RecipePage extends StatefulWidget {

  final String recipe;

  RecipePage({required this.recipe});
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
          ColorfulTextBuilder(widget.recipe, 30).getWidget(),
          const Placeholder(color: AppColors.green),
          CustomButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));}, text: 'back',),

        ],
      ),
    );
  }


}