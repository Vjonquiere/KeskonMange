import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/recipe_book_creation/viewmodels/new_book_viewmodel.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/widgets/recipe_preview.dart';
import '../../user_creations/views/my_creations_page.dart';

class NewBookPage extends StatelessWidget {
  const NewBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NewBookViewModel viewModel = Provider.of<NewBookViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            ColorfulTextBuilder(AppLocalizations.of(context)!.create_book, 30)
                .getWidget(),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.book_name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: viewModel.titleController,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.book_visibility,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Switch(
                  value: viewModel.public,
                  onChanged: viewModel.onPublicValueChanged,
                ),
              ],
            ),
          ),
          const CustomDivider(
            color: AppColors.pink,
          ),
          ColorfulTextBuilder(
            AppLocalizations.of(context)!.book_add_recipes,
            20,
            true,
          ).getWidget(),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchBar(
              leading: const Icon(Icons.search),
              onChanged: viewModel.searchUpdate,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                  padding: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (viewModel.isRecipeSelected(
                        viewModel.searchedRecipes[index],
                      )
                          ? AppColors.green
                          : Colors.transparent),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RecipePreview(recipe: viewModel.searchedRecipes[index]),
                      (viewModel.isRecipeSelected(
                        viewModel.searchedRecipes[index],
                      )
                          ? CustomButton(
                              iconSize: 32,
                              text: 'bin',
                              color: AppColors.red,
                              onPressed: () => viewModel.removeRecipe(
                                viewModel.searchedRecipes[index],
                              ),
                            )
                          : CustomButton(
                              iconSize: 32,
                              text: 'add',
                              onPressed: () => viewModel.addRecipe(
                                viewModel.searchedRecipes[index],
                              ),
                            )),
                    ],
                  ),
                );
              },
              itemCount: viewModel.searchRecipesCount,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomButton(
              iconSize: 32,
              onPressed: () {
                Navigator.of(context).pop(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const MyCreationsPage()),
                );
              },
              text: 'back',
            ),
            CustomButton(
              text: AppLocalizations.of(context)!.create,
              onPressed: () async {
                if (await viewModel.pushBook()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
