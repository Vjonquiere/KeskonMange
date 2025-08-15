import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../viewmodels/account_verification_viewmodel.dart';

class AccountVerificationStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AccountVerificationViewModel viewModel =
        Provider.of<AccountVerificationViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("Let's finalise the setup!", 40).getWidget(),
          ColorfulTextBuilder('Enter the code we have sent by mail', 20)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      // [username]
      TextField(
        controller: viewModel.verificationCodeController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Code (via mail)',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    ]);
  }
}
