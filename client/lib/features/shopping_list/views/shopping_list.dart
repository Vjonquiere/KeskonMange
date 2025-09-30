import 'package:client/features/shopping_list/viewmodels/shopping_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShoppingListViewModel viewModel = Provider.of(context);
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(
          children: [
            SegmentedButton(
              segments: [
                ButtonSegment(value: 7, label: Text("+7")),
                ButtonSegment(value: 10, label: Text("+10")),
                ButtonSegment(value: 14, label: Text("+14"))
              ],
              selected: viewModel.selected,
              emptySelectionAllowed: true,
              onSelectionChanged: viewModel.onSelectionChanged,
            )
          ],
        ),
        viewModel.state == WidgetStates.loading
            ? Container()
            : Expanded(
                child: ListView.builder(
                    itemCount: viewModel.ingredients.length,
                    itemBuilder: (BuildContext context, int index) => Row(
                          children: <Widget>[
                            Checkbox(
                              value: viewModel.done[viewModel.ingredients.keys
                                      .elementAt(index)] ??
                                  false,
                              onChanged: (bool? value) {
                                viewModel.onIngredientDoneSwitched(
                                    viewModel.ingredients.keys.elementAt(index),
                                    value);
                              },
                            ),
                            Text(
                                "${viewModel.ingredients.keys.elementAt(index).name} (${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]?.quantity} ${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]?.unit.unit})")
                          ],
                        )))
      ],
    )));
  }
}
