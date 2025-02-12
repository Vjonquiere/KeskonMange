import 'package:flutter/cupertino.dart';

import '../../model/month.dart';
import '../../utils/app_colors.dart';

class WeekWidget extends StatelessWidget{
  final Month _month;
  final int _index;
  final List<String> days = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];
  WeekWidget(this._month, this._index);

  @override
  Widget build(BuildContext context) {
    List<Widget> w = [];
    w.add(Text(
      days[_index],
      style: const TextStyle(color: AppColors.green, fontSize: 20),
    ));
    for (List<int> week in monthTemplate) {
      if (week[_index] == 0) {
        w.add(const SizedBox(
          width: 45,
          height: 66,
        ));
      } else {
        int d =
        plannedRecipes._indexWhere((item) => item.getDay() == week[_index]);
        w.add(_buildDay(week[_index], d != -1));
      }
    }
    return w;
  }

}
