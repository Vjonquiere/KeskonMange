import 'package:flutter/cupertino.dart';

import '../../../model/recipe/step.dart';
import '../../../utils/app_colors.dart';

class StepsList extends StatelessWidget {
  List<Step> steps;

  StepsList({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: steps.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Step ${index + 1}: ${steps[index].title}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index].stepText,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
