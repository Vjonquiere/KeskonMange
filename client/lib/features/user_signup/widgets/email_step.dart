import 'package:client/features/user_signup/viewmodels/email_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';

class EmailStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmailViewModel viewModel = Provider.of<EmailViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("How can we contact you?", 40).getWidget(),
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
    ]);
  }
}
