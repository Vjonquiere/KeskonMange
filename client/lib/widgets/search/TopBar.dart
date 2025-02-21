
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class TopBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(

      children: [
        //Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
        CircleAvatar(
          backgroundColor: AppColors.green,
          minRadius: 30,
          child: SvgPicture.asset(AppIcons.getIcon("search")),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
        const Text("Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
      ],
    );
  }

}