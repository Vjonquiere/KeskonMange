import 'package:client/features/recipe_calendar/widgets/week.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/month.dart';

class MonthWidget extends StatelessWidget {
  final Month _month;
  const MonthWidget(this._month, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> cols = <Widget>[];
    for (int i = 0; i < _month.monthTemplate[0].length; i++) {
      cols.add(WeekWidget(_month, i));
      cols.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cols,
    );
  }
}
