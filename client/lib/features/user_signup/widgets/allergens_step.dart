import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import '../../../utils/app_icons.dart';
import '../viewmodels/allergens_viewmodel.dart';

class AllergensStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AllergensViewModel viewModel = Provider.of<AllergensViewModel>(context);
    return Column(
      children: [
        ColorfulTextBuilder("Do you have allergens?", 40).getWidget(),
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 8.0, // Space between buttons
          runSpacing: 8.0, // Space between lines
          children: List.generate(allergens.length, (index) {
            return FilterChip(
              avatar: SvgPicture.asset(AppIcons.getIcon(allergens[index])),
              label: Text(allergens[index]),
              selected: viewModel.selected[index],
              onSelected: (bool selected) {
                viewModel.onSelectedSwitch(index, selected);
              },
            );
          }),
        ),
      ],
    );
  }
}
