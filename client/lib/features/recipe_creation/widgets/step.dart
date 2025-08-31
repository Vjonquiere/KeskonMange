import 'package:client/utils/app_colors.dart';
import 'package:client/model/recipe/step.dart' as st;
import 'package:flutter/material.dart';

class StepWidget extends StatelessWidget {
  final st.Step step;
  int stepNumber;

  StepWidget(this.step, {super.key, this.stepNumber = 1});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kaki, width: 3.0),
                    borderRadius: BorderRadius.all(Radius.zero)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "STEP $stepNumber: ${step.title}",
                      style: TextStyle(
                          color: AppColors.orange, fontWeight: FontWeight.bold),
                    ),
                    FractionallySizedBox(
                        widthFactor: 0.8, child: Text(step.stepText)),
                  ],
                ))),
        Positioned(
            top: -5,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.yellow, shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("X"),
              ),
            )),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration:
                  BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.edit,
                  size: 17.0,
                ),
              ),
            )),
      ],
    );
  }
}
