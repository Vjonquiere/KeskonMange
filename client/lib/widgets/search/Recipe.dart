import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class Recipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //const Padding(padding: EdgeInsets.symmetric(horizontal: 10) ),
        Card.filled(
          color: AppColors.beige,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(AppIcons.getIcon("placeholder_square")),
              width: 64,
              height: 64,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("PLAT",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start),
            Text("Preparation ... min",
                style: TextStyle(fontSize: 15), textAlign: TextAlign.start),
            Text("Cuisson ... min",
                style: TextStyle(fontSize: 15), textAlign: TextAlign.start)
          ],
        )
      ],
    );
  }
}
