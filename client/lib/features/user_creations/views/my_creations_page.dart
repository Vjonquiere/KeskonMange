import 'package:client/core/widget_states.dart';
import 'package:client/features/recipe_book_creation/viewmodels/new_book_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/new_recipe_viewmodel.dart';
import 'package:client/features/user_creations/viewmodels/my_creations_viewmodel.dart';
import 'package:client/features/user_creations/widgets/book_preview.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model/book/preview.dart';
import '../../../utils/app_icons.dart';
import '../../home/views/home_page.dart';
import '../../recipe_book_creation/views/new_book_page.dart';
import '../../recipe_creation/views/new_recipe_page.dart';

class MyCreationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyCreationViewModel viewModel = Provider.of<MyCreationViewModel>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
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
          children: [
            recipeBooksTab(context, viewModel),
            recipesTab(context),
          ],
        ),
      ),
    );
  }

  Widget recipeBooksTab(BuildContext context, MyCreationViewModel viewModel) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        switch (viewModel.state) {
          WidgetStates.idle => CircularProgressIndicator(),
          WidgetStates.loading => CircularProgressIndicator(),
          WidgetStates.ready => Expanded(
              child: ListView.builder(
                  itemCount: viewModel.booksCount,
                  itemBuilder: (context, index) => BookPreviewWidget(
                      viewModel.books[index], viewModel.getUserBooks))),
          WidgetStates.error => Text("Error"),
        },
        SizedBox(height: 10.0),
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                        create: (context) => NewBookViewModel(),
                        child: NewBookPage())))
                .then((res) => viewModel.getUserBooks());
          },
          child: Icon(Icons.add),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ColorfulTextBuilder(
                AppLocalizations.of(context)!.my_creations, 30, true)
            .getWidget(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AppIcons.getIcon("help"),
            width: 32,
          ),
        )
      ],
    );
  }

  Widget recipesTab(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        CustomButton(
          text: "add",
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => NewRecipeViewModel(),
                    child: NewRecipePage())));
          },
          scaleSize: 0.75,
        ),
      ],
    );
  }
}
