import 'package:client/core/widgets/allergens_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_icons.dart';
import '../viewmodels/allergens_viewmodel.dart';

class AllergensStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AllergensViewModel viewModel = Provider.of<AllergensViewModel>(context);
    return Column(
      children: [
        ColorfulTextBuilder(AppLocalizations.of(context)!.have_allergens, 40)
            .getWidget(),
        const SizedBox(height: 16.0),
        AllergensSelector(
            selected: viewModel.selected,
            onSelected: viewModel.onSelectedSwitch),
      ],
    );
  }
}
