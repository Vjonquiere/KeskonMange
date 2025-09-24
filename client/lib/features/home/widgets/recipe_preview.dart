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
  final int nameMaxLines;
  final DateTime? calendarEntry;

  const RecipePreview({
    required this.recipe,
    this.nameMaxLines = 1,
    this.homepage = false,
    this.calendarEntry,
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
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            Flexible(flex: 2, child: recipeInfo(context, homepage)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            /*Flexible(
              child: recipePlanning(context),
            ),*/
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.chefHat,
                      width: 24,
                      height: 24,
                      color: AppColors.blue,
                    ),
                    Text("${recipe.preparationTime.toString()} min"),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.oven,
                      width: 24,
                      height: 24,
                      color: AppColors.blue,
                    ),
                    Text("${recipe.cookTime.toString()} min"),
                  ],
                )
              ],
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
            Expanded(child: recipeInfo(context, homepage)),
          ],
        ),
      );
    }
  }

  Widget recipeImage(BuildContext context) {
    return Card.filled(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      color: AppColors.beige,
      elevation: 2,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: recipe.image == null
                ? Image(
                    image: AssetImage(AppIcons.getIcon("placeholder_square")),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    recipe.image!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
          )),
    );
  }

  Widget recipeInfo(BuildContext context, bool homepage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          recipe.title.toUpperCase(),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: nameMaxLines,
        ),
        homepage
            ? Container()
            : Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.chefHat,
                        width: 24,
                        height: 24,
                        color: AppColors.blue,
                      ),
                      Text("${recipe.preparationTime.toString()} min"),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.oven,
                        width: 24,
                        height: 24,
                        color: AppColors.blue,
                      ),
                      Text("${recipe.cookTime.toString()} min"),
                    ],
                  )
                ],
              ),
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
    if (calendarEntry == null)
      return FittedBox(
        child: Text("NOT FOUND"),
      );
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            //TODO: link to recipe planning + add internationalization
            Text(
              "${calendarEntry!.day.toString()}/${calendarEntry!.month.toString()}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "${calendarEntry!.hour}h${calendarEntry!.minute}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 5,
            ),
            /*SvgPicture.asset(
                AppIcons.getIcon("sunny"),
                width: 24,
                height: 24,
              ),*/
          ],
        ),
      ],
    );
  }
}
