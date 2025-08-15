import 'package:client/features/user_signup/viewmodels/username_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';

class UsernameStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UsernameViewModel viewModel = Provider.of<UsernameViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("How should we call you?", 40).getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      TextField(
        controller: viewModel.usernameController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Username',
        ),
      ),
    ]);
  }
}
