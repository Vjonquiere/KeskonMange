import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../home/views/home_page.dart';
import '../../user_creations/views/my_creations_page.dart';

class NewBookPage extends StatefulWidget {
  @override
  State<NewBookPage> createState() => _NewBookPageState();
}

class _NewBookPageState extends State<NewBookPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          ColorfulTextBuilder("Create a new book", 30).getWidget(),
          const Placeholder(color: AppColors.green),
          CustomButton(
            onPressed: () {
              Navigator.of(context).pop(
                  MaterialPageRoute(builder: (context) => MyCreationsPage()));
            },
            text: 'back',
          ),
        ],
      ),
    );
  }
}
