import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/rotary_number_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class NumberPicker extends StatelessWidget {
  String title;
  String buttonText;

  NumberPicker({super.key, required this.title, required this.buttonText});

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
                        maxValue: 10,
                        minValue: 0,
                        initialValue: 5,
                        onChanged: (value) {
                          print(value);
                        },
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
