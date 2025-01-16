import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class RecipeCard extends StatelessWidget {
  final String recipe;

  const RecipeCard({
    required this.recipe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.beige,
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child : IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(AppIcons.getIcon("veggie"), width: 32, height: 32),
                  SvgPicture.asset(AppIcons.getIcon("meal"), width: 32, height: 32),
                  SvgPicture.asset(AppIcons.getIcon("cake"), width: 32, height: 32),
                ],
              ),
            ),

            // Center Content
            Padding(
              padding: const EdgeInsets.all(20.0), // Add padding around the column
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        image: AssetImage(AppIcons.getIcon("placeholder")),
                        width: 250,
                        //height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text("Recipe title"),
                  ],
                ),
            ),
          ],
        ),
      )

    );
  }
}
