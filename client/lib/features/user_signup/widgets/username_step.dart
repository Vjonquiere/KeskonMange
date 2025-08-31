import 'package:client/features/user_signup/viewmodels/username_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';

class UsernameStep extends StatelessWidget {
  const UsernameStep({super.key});

  @override
  Widget build(BuildContext context) {
    final UsernameViewModel viewModel = Provider.of<UsernameViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder(AppLocalizations.of(context)!.choose_username, 40)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      TextField(
        controller: viewModel.usernameController,
        decoration: InputDecoration(
          filled: true,
          labelText: AppLocalizations.of(context)!.username,
        ),
      ),
    ],);
  }
}
