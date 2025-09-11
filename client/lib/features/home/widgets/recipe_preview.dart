import 'package:client/features/recipe/viewmodels/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../recipe/views/recipe_page.dart';
import 'package:client/model/recipe/preview.dart' as rp_model;

class RecipePreview extends StatelessWidget {
  final rp_model.RecipePreview recipe;
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
          Navigator.of(context).push(
            MaterialPageRoute<RecipePage>(
              builder: (BuildContext context) => ChangeNotifierProvider(
                  create: (context) => RecipeViewModel(recipe.id),
                  child: RecipePage()),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: recipeImage(context),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Flexible(flex: 2, child: recipeInfo(context)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Flexible(
              child: recipePlanning(context),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Flexible(
              child: predictedMeal(context),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<RecipePage>(
              builder: (BuildContext context) => ChangeNotifierProvider(
                  create: (context) => RecipeViewModel(recipe.id),
                  child: RecipePage()),
            ),
          );
        },
        child: Row(
          children: <Widget>[
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
        child: recipe.image == null ?Image(
          image: AssetImage(AppIcons.getIcon("placeholder_square")),
          width: 64,
          height: 64,
        ) : Image.network(recipe.image!, width: 64,
          height: 64,),
      ),
    );
  }

  Widget recipeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          recipe.title.toUpperCase(),
          softWrap: true,
        ),
        Text(
          AppLocalizations.of(context)!
              .preparation_time(recipe.preparationTime),
        ),
        Text(AppLocalizations.of(context)!.cooking_time(recipe.cookTime)),
      ],
    );
  }

  Widget recipePlanning(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            AppIcons.getIcon("sunny"),
            width: 32,
            height: 32,
          ),
          const Padding(padding: EdgeInsets.all(5.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
