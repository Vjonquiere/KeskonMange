import 'package:client/features/recipe_creation/viewmodels/recipe_review_viewmodel.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RecipeReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecipeReviewViewModel viewModel =
        Provider.of<RecipeReviewViewModel>(context);
    return Column(
      children: [
        Row(
          children: [Text("Recipe name:"), Text(viewModel.recipe.title)],
        ),
        Row(
          children: [
            SvgPicture.asset(AppIcons.getIcon("list"), width: 32),
            Text("For x persons:")
          ],
        ),
        Wrap(
          children: List.generate(
              viewModel.ingredients.length,
              (int index) => Text(
                  "${viewModel.ingredients.keys.elementAt(index).name} ${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]?.quantity} ${viewModel.ingredients[viewModel.ingredients.keys.elementAt(index)]?.unit.toString()}")),
          runAlignment: WrapAlignment.center,
        ),
      ],
    );
  }
}
