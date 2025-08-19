import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../viewmodels/book_viewmodel.dart';

class Book extends StatelessWidget {
  const Book({super.key});

  Widget topContainer(BuildContext context, BookViewModel viewModel) {
    return Row(
      children: [
        Card.filled(
          color: AppColors.beige,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(AppIcons.getIcon("placeholder_square")),
              width: 100,
              height: 100,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.book.name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                "Created on ${viewModel.book.creationDate.day}/${viewModel.book.creationDate.month}/${viewModel.book.creationDate.year}"),
            Text("By ${viewModel.book.ownerId}"),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.getIcon(
                      viewModel.book.public ? "public" : "private"),
                  width: 16,
                ),
                const SizedBox(width: 10.0),
                Text("${viewModel.book.public ? "Public" : "Private"} album"),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              text: "trash",
              onPressed: () {},
              color: AppColors.red,
            ),
            CustomButton(
              text: "upload",
              onPressed: () {},
              color: AppColors.yellow,
            ),
          ],
        )
      ],
    );
  }

  Widget recipeList(BuildContext context, BookViewModel viewModel) {
    return Expanded(
        child: ListView.builder(
            itemCount: viewModel.recipeCount,
            itemBuilder: (BuildContext context, int index) {
              return RecipePreview(recipe: viewModel.recipes[index]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    BookViewModel viewModel = Provider.of<BookViewModel>(context);
    return Scaffold(
      body: switch (viewModel.state) {
        WidgetStates.idle => CircularProgressIndicator(),
        WidgetStates.loading => CircularProgressIndicator(),
        WidgetStates.ready => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsetsGeometry.only(top: 25)),
              topContainer(context, viewModel),
              CustomDivider(),
              recipeList(context, viewModel),
            ],
          ),
        WidgetStates.error => Text("Error"),
      },
      floatingActionButton: CustomButton(
          text: "back",
          onPressed: () {
            Navigator.of(context).pop();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
