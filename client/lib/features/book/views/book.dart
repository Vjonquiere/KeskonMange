import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/book/widgets/delete_book_dialog.dart';
import 'package:client/features/home/widgets/recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
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
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.book.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context)!
                .book_creation(viewModel.book.creationDate)),
            Text(AppLocalizations.of(context)!
                .book_owner(viewModel.book.ownerId)),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.getIcon(
                      viewModel.book.public ? "public" : "private"),
                  width: 16,
                ),
                const SizedBox(width: 10.0),
                Text(
                    viewModel.book.public ? AppLocalizations.of(context)!.book_public : AppLocalizations.of(context)!.book_private),
              ],
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              iconSize: 32,
              text: "trash",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: DeleteBookDialog(viewModel.deleteBook),
                        ));
              },
              color: AppColors.red,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomButton(
              iconSize: 32,
              text: "upload",
              onPressed: () {},
              color: AppColors.yellow,
            ),
          ],
        ),
        CustomButton(
          iconSize: 32,
          text: "pen",
          onPressed: viewModel.switchEditMode,
          color: AppColors.blue,
        ),
      ],
    );
  }

  Widget recipeList(BuildContext context, BookViewModel viewModel) {
    return Expanded(
        child: ListView.builder(
            itemCount: viewModel.recipeCount,
            itemBuilder: (BuildContext context, int index) {
              if (viewModel.editMode) {
                return Row(
                  children: [
                    RecipePreview(recipe: viewModel.recipes[index]),
                    CustomButton(
                      text: "trash",
                      onPressed: () {
                        viewModel.deleteRecipe(viewModel.recipes[index].id);
                      },
                      iconSize: 32,
                      color: AppColors.red,
                    )
                  ],
                );
              }
              return RecipePreview(recipe: viewModel.recipes[index]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    BookViewModel viewModel = Provider.of<BookViewModel>(context);
    return Scaffold(
      body: SafeArea(
          child: switch (viewModel.state) {
        WidgetStates.idle => const CircularProgressIndicator(),
        WidgetStates.loading => const CircularProgressIndicator(),
        WidgetStates.ready => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsetsGeometry.only(top: 25)),
              topContainer(context, viewModel),
              const CustomDivider(),
              viewModel.editMode
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.book_edit_mode)),
                    )
                  : Container(),
              recipeList(context, viewModel),
            ],
          ),
        WidgetStates.error => const Text("Error"),
        WidgetStates.dispose => const Text("Dispose"),
      }),
      floatingActionButton: CustomButton(
          iconSize: 32,
          text: "back",
          onPressed: () {
            Navigator.of(context).pop();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
