import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/rotary_number_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class NumberPicker extends StatelessWidget {
  String title;
  String buttonText;
  void Function(int) onValueChanged;
  int initialValue;
  int maxValue;
  int minValue;

  NumberPicker(
      {super.key,
      required this.title,
      required this.buttonText,
      required this.onValueChanged,
      this.initialValue = 5,
      this.maxValue = 10,
      this.minValue = 1});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        color: AppColors.blue,
        text: buttonText,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                color: AppColors.beige,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ColorfulTextBuilder(title, 30, true).getWidget(),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      RotaryNumberPicker(
                        maxValue: maxValue,
                        minValue: minValue,
                        initialValue: initialValue,
                        onChanged: onValueChanged,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      CustomButton(
                        text: 'Confirm',
                        fontSize: 25,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
