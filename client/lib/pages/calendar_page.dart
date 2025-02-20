import 'dart:convert';

import 'package:client/http/calendar/CompleteMonthRequest.dart';
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
  late Future<int> requestResult;
  final currentMonthRequest = CompleteMonthRequest(0);
  final List<String> months = ["Janvier", "Février", "Mars", "Avril"];

  @override
  void initState() {
    super.initState();
    requestResult = currentMonthRequest.send();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white, // Set the background color
      child: Column(
        children: [
          ColorfulTextBuilder("Calendar", 30).getWidget(),
          FutureBuilder(
              future: requestResult,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! == 200) {
                    Month current = Month.fromJson(
                        jsonDecode(currentMonthRequest.getBody()));
                    return Column(
                      children: [
                        Text(
                          "${months[current.month - 1]} ${current.year}",
                          style: const TextStyle(
                              color: AppColors.blue, fontSize: 25),
                        ),
                        MonthWidget(current),
                      ],
                    );
                  }
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
    );
  }
}
