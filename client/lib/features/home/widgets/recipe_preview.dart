import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../recipe/views/recipe_page.dart';
import 'package:client/model/recipe/preview.dart' as rpModel;

class RecipePreview extends StatelessWidget {
  final rpModel.RecipePreview recipe;
  final bool homepage;

  const RecipePreview({
    required this.recipe,
    this.homepage = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (homepage) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RecipePage(recipe: recipe)));
        },
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: recipeImage(context),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Flexible(flex: 2, child: recipeInfo(context)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Flexible(
              flex: 1,
              child: recipePlanning(context),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Flexible(
              flex: 1,
              child: predictedMeal(context),
            )
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RecipePage(recipe: recipe)));
        },
        child: Row(
          children: [
            const SizedBox(width: 20.0),
            recipeImage(context),
            const SizedBox(width: 20.0),
            recipeInfo(context),
            const SizedBox(width: 20.0),
          ],
        ),
      );
    }
  }

  Widget recipeImage(BuildContext context) {
    return Card.filled(
      color: AppColors.beige,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image: AssetImage(AppIcons.getIcon("placeholder_square")),
          width: 64,
          height: 64,
        ),
      ),
    );
  }

  Widget recipeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.title.toUpperCase(),
          softWrap: true,
        ),
        Text(AppLocalizations.of(context)!.preparation_time(recipe.preparationTime)),
        Text(AppLocalizations.of(context)!.cooking_time(recipe.cookTime))
      ],
    );
  }

  Widget recipePlanning(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO: link these to recipes + add internationalization
        Text(
          "E P D",
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7),
        ),
        Text(
          "nb pers",
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7),
        ),
      ],
    );
  }

  Widget predictedMeal(BuildContext context) {
    return FittedBox(
      // Scales the content to fit
      fit: BoxFit.contain,
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.getIcon("sunny"),
            width: 32,
            height: 32,
          ),
          const Padding(padding: EdgeInsets.all(5.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO: link to recipe planning + add internationalization
              Text(
                "day".toUpperCase(),
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 0.7),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "time",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 0.7),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
