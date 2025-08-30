import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/recipe_book_creation/viewmodels/new_book_viewmodel.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/views/home_page.dart';
import '../../home/widgets/recipe_preview.dart';
import '../../user_creations/views/my_creations_page.dart';

class NewBookPage extends StatelessWidget {
  const NewBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    NewBookViewModel viewModel = Provider.of<NewBookViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            ColorfulTextBuilder(AppLocalizations.of(context)!.create_book, 30)
                .getWidget(),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.book_name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: TextField(
                    controller: viewModel.titleController,
                  ),
                  width: 200,
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.book_visibility,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 10,
                  ),
                  Switch(
                      value: viewModel.public,
                      onChanged: viewModel.onPublicValueChanged),
                ],
              )),
          CustomDivider(
            color: AppColors.pink,
          ),
          ColorfulTextBuilder(
                  AppLocalizations.of(context)!.book_add_recipes, 20, true)
              .getWidget(),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SearchBar(
              leading: Icon(Icons.search),
              onChanged: viewModel.searchUpdate,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                  padding: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: (viewModel.isRecipeSelected(
                                  viewModel.searchedRecipes[index])
                              ? AppColors.green
                              : Colors.transparent),
                          width: 3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RecipePreview(recipe: viewModel.searchedRecipes[index]),
                      (viewModel.isRecipeSelected(
                              viewModel.searchedRecipes[index])
                          ? CustomButton(
                              iconSize: 32,
                              text: 'bin',
                              color: AppColors.red,
                              onPressed: () => viewModel.removeRecipe(
                                  viewModel.searchedRecipes[index]))
                          : CustomButton(
                              iconSize: 32,
                              text: 'add',
                              onPressed: () => viewModel.addRecipe(
                                  viewModel.searchedRecipes[index]))),
                    ],
                  ));
            },
            itemCount: viewModel.searchRecipesCount,
          )),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            iconSize: 32,
            onPressed: () {
              Navigator.of(context).pop(
                  MaterialPageRoute(builder: (context) => MyCreationsPage()));
            },
            text: 'back',
          ),
          CustomButton(
              text: AppLocalizations.of(context)!.create,
              onPressed: () async {
                if (await viewModel.pushBook()) {
                  Navigator.of(context).pop();
                }
              }),
        ],
      )),
    );
  }
}
