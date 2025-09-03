import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../utils/app_icons.dart';

class AllergensSelector extends StatelessWidget {
  final void Function(int, bool) onSelected;
  final List<bool> selected;

  AllergensSelector(
      {super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List<FilterChip>.generate(allergens.length, (int index) {
        return FilterChip(
          avatar: SvgPicture.asset(AppIcons.getIcon(allergens[index])),
          label: Text(allergens[index]),
          selected: selected[index],
          onSelected: (bool selected) {
            onSelected(index, selected);
          },
        );
      }),
    );
  }
}
