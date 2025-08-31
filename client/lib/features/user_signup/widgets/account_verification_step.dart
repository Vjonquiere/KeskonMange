import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodels/account_verification_viewmodel.dart';

class AccountVerificationStep extends StatelessWidget {
  const AccountVerificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountVerificationViewModel viewModel =
        Provider.of<AccountVerificationViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder(
                  AppLocalizations.of(context)!.verification_finalize, 40)
              .getWidget(),
          ColorfulTextBuilder(
                  AppLocalizations.of(context)!.verification_code, 20)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      // [username]
      TextField(
        controller: viewModel.verificationCodeController,
        decoration: InputDecoration(
          filled: true,
          labelText: AppLocalizations.of(context)!.email_code,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    ]);
  }
}
