import 'package:client/features/user_signup/viewmodels/email_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';

class EmailStep extends StatelessWidget {
  const EmailStep({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailViewModel viewModel = Provider.of<EmailViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder(AppLocalizations.of(context)!.give_email, 40)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      // [username]
      TextField(
        controller: viewModel.emailController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Email',
        ),
      ),
    ],);
  }
}
