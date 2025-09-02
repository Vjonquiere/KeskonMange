import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/views/home_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white, // Set the background color
      child: Column(
        children: <Widget>[
          ColorfulTextBuilder(AppLocalizations.of(context)!.user, 30)
              .getWidget(),
          const Placeholder(color: AppColors.green),
          CustomButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<HomePage>(
                  builder: (BuildContext context) => const HomePage()));
            },
            text: 'back',
          ),
        ],
      ),
    );
  }
}
