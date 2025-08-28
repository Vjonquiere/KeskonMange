import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodels/post_code_viewmodel.dart';

class PostCodeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PostCodeViewModel viewModel = Provider.of<PostCodeViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder(AppLocalizations.of(context)!.housing, 40)
              .getWidget(),
          ColorfulTextBuilder(AppLocalizations.of(context)!.housing_info, 20)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      TextField(
        controller: viewModel.postcodeController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Postcode',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    ]);
  }
}
