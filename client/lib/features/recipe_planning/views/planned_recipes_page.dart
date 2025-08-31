import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../home/views/home_page.dart';

class PlannedRecipesPage extends StatefulWidget {
  const PlannedRecipesPage({super.key});

  @override
  State<PlannedRecipesPage> createState() => _PlannedRecipesPageState();
}

class _PlannedRecipesPageState extends State<PlannedRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white, // Set the background color
      child: Column(
        children: [
          ColorfulTextBuilder("PlannedRecipes", 30).getWidget(),
          const Placeholder(color: AppColors.green),
          CustomButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const HomePage()));
            },
            text: 'back',
          ),
        ],
      ),
    );
  }
}
