import 'dart:ffi';

import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/data/usecases/recipe/get_recipe_from_id_use_case.dart';
import 'package:client/data/usecases/recipes/get_last_recipes_ids_use_case.dart';
import 'package:client/features/recipe_search/viewmodels/search_page_viewmodel.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/widgets/search/Recipe.dart';
import 'package:client/widgets/search/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../widgets/search/Filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    SearchPageViewModel viewModel = Provider.of<SearchPageViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            const TopBar(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            const Filter(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            switch (viewModel.state) {
              WidgetStates.idle => CircularProgressIndicator(),
              WidgetStates.loading => throw UnimplementedError(),
              WidgetStates.ready => Expanded(
                child: ListView.builder(
                  itemCount: viewModel.recipesCount,
                  itemBuilder: (context, index) {
                    RecipePreview recipe = viewModel.getRecipe(index);
                    return Recipe(
                      recipe.title,
                      "",
                      recipe.preparationTime,
                      recipe.cookTime,
                    );
                  },
                ),
              ),
              WidgetStates.error => throw UnimplementedError(),
            },
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'back',
            ),
          ],
        ),
      ),
    );

  }
}
