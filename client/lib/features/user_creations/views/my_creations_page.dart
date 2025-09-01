import 'package:client/core/widget_states.dart';
import 'package:client/features/recipe_book_creation/viewmodels/new_book_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/new_recipe_viewmodel.dart';
import 'package:client/features/user_creations/viewmodels/my_creations_viewmodel.dart';
import 'package:client/features/user_creations/widgets/book_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_icons.dart';
import '../../recipe_book_creation/views/new_book_page.dart';
import '../../recipe_creation/views/new_recipe_page.dart';

class MyCreationsPage extends StatelessWidget {
  const MyCreationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MyCreationViewModel viewModel =
        Provider.of<MyCreationViewModel>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: AppLocalizations.of(context)!.recipe_books,
              ),
              Tab(
                text: AppLocalizations.of(context)!.recipes,
              ),
            ],
          ),
          title: title(context),
        ),
        body: TabBarView(
          children: <Widget>[
            recipeBooksTab(context, viewModel),
            recipesTab(context),
          ],
        ),
      ),
    );
  }

  Widget recipeBooksTab(BuildContext context, MyCreationViewModel viewModel) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10.0),
        switch (viewModel.state) {
          WidgetStates.idle => const CircularProgressIndicator(),
          WidgetStates.loading => const CircularProgressIndicator(),
          WidgetStates.dispose => const Text("dispose"),
          WidgetStates.ready => Expanded(
              child: ListView.builder(
                itemCount: viewModel.booksCount,
                itemBuilder: (BuildContext context, int index) =>
                    BookPreviewWidget(
                  viewModel.books[index],
                  viewModel.getUserBooks,
                ),
              ),
            ),
          WidgetStates.error => const Text("Error"),
        },
        const SizedBox(height: 10.0),
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute<NewBookPage>(
                    builder: (BuildContext context) => ChangeNotifierProvider<NewBookViewModel>(
                      create: (BuildContext context) => NewBookViewModel(),
                      child: const NewBookPage(),
                    ),
                  ),
                )
                .then((NewBookPage? res) => viewModel.getUserBooks());
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ColorfulTextBuilder(
          AppLocalizations.of(context)!.my_creations,
          30,
          true,
        ).getWidget(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AppIcons.getIcon("help"),
            width: 32,
          ),
        ),
      ],
    );
  }

  Widget recipesTab(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10.0),
        CustomButton(
          text: "add",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<NewRecipePage>(
                builder: (BuildContext context) => ChangeNotifierProvider<NewRecipeViewModel>(
                  create: (BuildContext context) => NewRecipeViewModel(),
                  child: const NewRecipePage(),
                ),
              ),
            );
          },
          iconSize: 32,
        ),
      ],
    );
  }
}
