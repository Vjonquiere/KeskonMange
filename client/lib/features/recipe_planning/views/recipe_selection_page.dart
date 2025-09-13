import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:client/features/recipe_planning/viewmodels/recipe_selection_viewmodel.dart';
import 'package:client/model/recipe/preview.dart' as model;
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecipeSelectionViewModel viewModel =
        Provider.of<RecipeSelectionViewModel>(context);
    return Expanded(
        child: Column(
      children: [
        SearchBar(
          leading: Icon(Icons.search),
          onChanged: viewModel.onQueryChanged,
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: viewModel.fetchedRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  final model.RecipePreview recipe =
                      viewModel.fetchedRecipes.elementAt(index);
                  final bool selected =
                      viewModel.selectedRecipes.contains(recipe);
                  return Row(
                    children: [
                      Expanded(
                          child: RecipePreview(
                        recipe: recipe,
                      )),
                      IconButton(
                          onPressed: () {
                            viewModel.switchRecipeSelection(recipe);
                          },
                          icon: Icon(
                            Icons.check_circle_outline_outlined,
                            color: selected ? AppColors.green : null,
                          ))
                    ],
                  );
                }))
      ],
    ));
  }
}
