import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class Day extends StatelessWidget {
  final int _day;
  final bool _done;

  const Day(this._day, this._done, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.yellow, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          alignment: Alignment.center,
          width: 30,
          height: 50,
          color: AppColors.beige,
          child: _done == false
              ? const SizedBox.shrink()
              : ClipOval(
                  child: Container(
                    width: 25,
                    height: 25,
                    color: AppColors.yellow,
                    child: Center(
                      child: Text(
                        "$_day",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
