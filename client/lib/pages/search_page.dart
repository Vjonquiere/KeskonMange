import 'package:client/custom_widgets/custom_buttons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/widgets/search/Recipe.dart';
import 'package:client/widgets/search/TopBar.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../widgets/search/Filter.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          TopBar(),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Filter(),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Recipe(),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Recipe(),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Recipe(),
          //const Placeholder(color: AppColors.green),
          CustomButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            },
            text: 'back',
          ),
        ],
      ),),);
  }
}
