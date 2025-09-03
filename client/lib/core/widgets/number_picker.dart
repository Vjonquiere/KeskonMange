import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/rotary_number_picker.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/app_colors.dart';

class NumberPicker extends StatelessWidget {
  final String title;
  final String buttonText;
  final void Function(int) onValueChanged;
  final int initialValue;
  final int maxValue;
  final int minValue;

  NumberPicker({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onValueChanged,
    this.initialValue = 5,
    this.maxValue = 10,
    this.minValue = 1,
  });

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
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      RotaryNumberPicker(
                        maxValue: maxValue,
                        minValue: minValue,
                        initialValue: initialValue,
                        onChanged: onValueChanged,
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      CustomButton(
                        text: AppLocalizations.of(context)!.confirm,
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
