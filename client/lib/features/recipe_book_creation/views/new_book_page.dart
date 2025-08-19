import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/recipe_book_creation/viewmodels/new_book_viewmodel.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../home/views/home_page.dart';
import '../../home/widgets/recipe_preview.dart';
import '../../user_creations/views/my_creations_page.dart';

class NewBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewBookViewModel viewModel = Provider.of<NewBookViewModel>(context);
    return Scaffold(
      body: Column(
        children: [
          ColorfulTextBuilder("Create a new book", 30).getWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter a book name:"),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                child: TextField(
                  controller: viewModel.titleController,
                ),
                width: 300,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Is this book public ?"),
              SizedBox(
                width: 10,
              ),
              Switch(
                  value: viewModel.public,
                  onChanged: viewModel.onPublicValueChanged),
            ],
          ),
          CustomDivider(
            color: AppColors.pink,
          ),
          Text("Add recipes"),
          SearchBar(
            leading: Icon(Icons.search),
            onChanged: viewModel.searchUpdate,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return RecipePreview(recipe: viewModel.searchedRecipes[index]);
            },
            itemCount: viewModel.searchRecipesCount,
          )),
          CustomButton(text: "Create", onPressed: viewModel.pushBook),
          CustomButton(
            onPressed: () {
              Navigator.of(context).pop(
                  MaterialPageRoute(builder: (context) => MyCreationsPage()));
            },
            text: 'back',
          ),
        ],
      ),
    );
  }
}
