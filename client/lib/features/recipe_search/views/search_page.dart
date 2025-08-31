import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/features/recipe_search/viewmodels/search_page_viewmodel.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/widgets/search/Recipe.dart';
import 'package:client/widgets/search/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/search/Filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final SearchPageViewModel viewModel = Provider.of<SearchPageViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20)),
            const TopBar(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            const Filter(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            switch (viewModel.state) {
              WidgetStates.idle => const CircularProgressIndicator(),
              WidgetStates.loading => throw UnimplementedError(),
              WidgetStates.dispose => const Text("dispose"),
              WidgetStates.ready => Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.recipesCount,
                    itemBuilder: (context, index) {
                      final RecipePreview recipe = viewModel.getRecipe(index);
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
