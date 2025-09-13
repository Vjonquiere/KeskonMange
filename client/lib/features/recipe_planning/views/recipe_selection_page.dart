import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:client/features/recipe_planning/viewmodels/recipe_selection_viewmodel.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecipeSelectionViewModel>(context);
    return Expanded(
        child: Column(
      children: [
        SearchBar(
          leading: Icon(Icons.search),
          controller: viewModel.queryController,
          onChanged: viewModel.onQueryChanged,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: viewModel.fetchedRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                          child: RecipePreview(
                        recipe: viewModel.fetchedRecipes.elementAt(index),
                        homepage: false,
                      )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.check_circle_outline_outlined,
                          ))
                    ],
                  );
                }))
      ],
    ));
  }
}
