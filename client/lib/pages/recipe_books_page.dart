import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/custom_buttons.dart';
import 'home_page.dart';

class RecipeBooksPage extends StatefulWidget {
  @override
  State<RecipeBooksPage> createState() => _RecipeBooksPageState();
}

class _RecipeBooksPageState extends State<RecipeBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white, // Set the background color
      child: Column(
        children: [
          ColorfulTextBuilder("RecipeBooks", 30).getWidget(),
          const Placeholder(color: AppColors.green),
          CustomButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            },
            text: 'back',
          ),
        ],
      ),
    );
  }
}
