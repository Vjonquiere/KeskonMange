import 'package:client/utils/app_colors.dart';
import 'package:client/features/recipe_calendar/widgets/month.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/views/home_page.dart';
import '../viewmodels/calendar_viewmodel.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //TODO: internationalize the months cleanly
  final List<String> months = <String>[
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    final CalendarViewModel viewModel = Provider.of<CalendarViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ColorfulTextBuilder(
                    AppLocalizations.of(context)!.calendar, 40, true)
                .getWidget(),
            switch (viewModel.state) {
              WidgetStates.idle => Container(),
              WidgetStates.loading => const CircularProgressIndicator(),
              WidgetStates.error => const Text("error"),
              WidgetStates.dispose => const Text("disppose"),
              WidgetStates.ready => GestureDetector(
                  onVerticalDragEnd: (DragEndDetails details) {
                    final double dy = details.velocity.pixelsPerSecond.dy;
                    const int swipeThreshold = 300;
                    if (dy < -swipeThreshold) {
                      viewModel.nextMonth();
                    } else if (dy > swipeThreshold) {
                      viewModel.previousMonth();
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: viewModel.previousMonth,
                        icon: const Icon(
                          Icons.arrow_drop_up,
                          size: 50.0,
                        ),
                      ),
                      Text(
                        "${months[viewModel.currentMonth.month - 1]} ${viewModel.currentMonth.year}",
                        style: const TextStyle(
                            color: AppColors.blue, fontSize: 25),
                      ),
                      MonthWidget(viewModel.currentMonth),
                      IconButton(
                        onPressed: viewModel.nextMonth,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
            },
            CustomButton(
              iconSize: 32,
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'back',
            ),
          ],
        ),
      ),
    );
  }
}
