import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:client/features/recipe_search/viewmodels/search_page_viewmodel.dart';
import 'package:client/widgets/search/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/search/filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final SearchPageViewModel viewModel =
        Provider.of<SearchPageViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20)),
            TopBar(
              onSearchTextChanged: viewModel.onSearchTextChanged,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Filter(viewModel.addFilter),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            switch (viewModel.state) {
              WidgetStates.idle => const CircularProgressIndicator(),
              WidgetStates.loading => throw UnimplementedError(),
              WidgetStates.dispose => const Text("dispose"),
              WidgetStates.ready => Expanded(
                  child: ListView.builder(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    itemCount: viewModel.recipesCount,
                    itemBuilder: (BuildContext context, int index) {
                      return RecipePreview(
                        recipe: viewModel.getRecipe(index),
                        nameMaxLines: 2,
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
