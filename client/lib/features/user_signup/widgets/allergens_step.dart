import 'package:client/core/widgets/allergens_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodels/allergens_viewmodel.dart';

class AllergensStep extends StatelessWidget {
  const AllergensStep({super.key});

  @override
  Widget build(BuildContext context) {
    final AllergensViewModel viewModel =
        Provider.of<AllergensViewModel>(context);
    return Column(
      children: <Widget>[
        ColorfulTextBuilder(AppLocalizations.of(context)!.have_allergens, 40)
            .getWidget(),
        const SizedBox(height: 16.0),
        AllergensSelector(
          selected: viewModel.selected,
          onSelected: viewModel.onSelectedSwitch,
        ),
      ],
    );
  }
}
