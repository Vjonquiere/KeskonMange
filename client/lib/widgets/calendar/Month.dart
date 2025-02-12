import 'package:client/http/calendar/CompleteMonthRequest.dart';
import 'package:flutter/cupertino.dart';

import '../../model/month.dart';

class MonthWidget extends StatelessWidget{
  final Month _month;
  MonthWidget(this._month);

  @override
  Widget build(BuildContext context) {
    List<Widget> cols = [];
    for (int i = 0; i < _month.monthTemplate[0].length; i++) {
      cols.add(Column(
        children: _buildWeek(i),
      ));
      cols.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)));
    }
    return Column(children: cols);
  }


}
