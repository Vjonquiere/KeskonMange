import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/features/shopping_list/viewmodels/shopping_list_viewmodel.dart';
import 'package:client/model/ingredient_quantity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget_states.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShoppingListViewModel viewModel = Provider.of(context);
    return Scaffold(
        floatingActionButton: CustomButton(
          text: "back",
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 32,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                : viewModel.ingredients.isEmpty
                    ? Text("Nothing found")
                    : Expanded(
                        child: ListView.builder(
                            itemCount: viewModel.ingredients.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool? selected = viewModel.done[
                                  viewModel.ingredients.keys.elementAt(index)];
                              String ingredients =
                                  "${viewModel.ingredients.keys.elementAt(index).name} (";
                              bool fist = true;
                              for (IngredientQuantity ing
                                  in viewModel.ingredients[viewModel
                                      .ingredients.keys
                                      .elementAt(index)]!) {
                                if (fist) {
                                  ingredients +=
                                      "${ing.quantity} ${ing.unit.unit.toString().split(".").last}";
                                  fist = false;
                                } else {
                                  ingredients +=
                                      " + ${ing.quantity} ${ing.unit.unit.toString().split(".").last}";
                                }
                              }
                              ingredients += ")";
                              return Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: selected ?? false,
                                    onChanged: (bool? value) {
                                      viewModel.onIngredientDoneSwitched(
                                          viewModel.ingredients.keys
                                              .elementAt(index),
                                          value);
                                    },
                                  ),
                                  Expanded(
                                      child: Text(
                                    softWrap: true,
                                    maxLines: 3,
                                    ingredients,
                                    overflow: TextOverflow.ellipsis,
                                    style: (selected != null && selected)
                                        ? const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 3.0)
                                        : null,
                                  ))
                                ],
                              );
                            }))
          ],
        )));
  }
}
