import 'dart:convert';

import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/data/usecases/get_complete_month_use_case.dart';
import 'package:client/model/month.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/widgets/calendar/Month.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/custom_buttons.dart';
import 'home_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<Month> requestResult;
  final currentMonthUseCase =
      GetCompleteMonthUseCase(RepositoriesManager().getCalendarRepository(), 0);
  final List<String> months = [
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
    "December"
  ];

  @override
  void initState() {
    super.initState();
    requestResult = currentMonthUseCase.execute();
  }

  void switchToNextMonth() {
    if (currentMonthUseCase.monthCount >= 0) return;
    setState(() {
      currentMonthUseCase.monthCount++;
      requestResult = currentMonthUseCase.execute();
    });
  }

  void switchToPreviousMonth() {
    setState(() {
      currentMonthUseCase.monthCount--;
      requestResult = currentMonthUseCase.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          ColorfulTextBuilder("Calendar", 40, true).getWidget(),
          FutureBuilder(
              future: requestResult,
              builder: (BuildContext context, AsyncSnapshot<Month> snapshot) {
                if (snapshot.hasData) {
                  Month current = snapshot.requireData;
                  return GestureDetector(
                    onVerticalDragEnd: (details) {
                      double dy = details.velocity.pixelsPerSecond.dy;
                      const swipeThreshold = 300;
                      if (dy < -swipeThreshold) {
                        switchToNextMonth();
                      } else if (dy > swipeThreshold) {
                        switchToPreviousMonth();
                      }
                    },
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              switchToPreviousMonth();
                            },
                            icon: Icon(
                              Icons.arrow_drop_up,
                              size: 50.0,
                            )),
                        Text(
                          "${months[current.month - 1]} ${current.year}",
                          style: const TextStyle(
                              color: AppColors.blue, fontSize: 25),
                        ),
                        MonthWidget(current),
                        IconButton(
                            onPressed: () {
                              switchToNextMonth();
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 50.0,
                            )),
                      ],
                    ),
                  );
                  return const Text("Nothing found");
                } else if (snapshot.hasError) {
                  return const Text("Error");
                }
                return const CircularProgressIndicator();
              }),
          CustomButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(MaterialPageRoute(builder: (context) => HomePage()));
            },
            text: 'back',
          ),
        ],
      ),
    ));
  }
}
