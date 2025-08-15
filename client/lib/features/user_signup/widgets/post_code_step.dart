import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../viewmodels/post_code_viewmodel.dart';

class PostCodeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PostCodeViewModel viewModel = Provider.of<PostCodeViewModel>(context);
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("Where do you live?", 40).getWidget(),
          ColorfulTextBuilder(
                  'This data will be used to give you recipes based on the weather.',
                  20)
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
