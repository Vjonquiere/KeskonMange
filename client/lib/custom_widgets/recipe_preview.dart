import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

import '../pages/recipe_page.dart';

class RecipePreview extends StatelessWidget {
  final String recipe;
  final bool homepage;
  //final Color color;
  //final double scaleSize;


  const RecipePreview({
    required this.recipe,
    this.homepage = false,
    //this.color = AppColors.green,
    //this.scaleSize = 0.5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if(homepage ){
      return
          InkWell(
            onTap : () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipePage(recipe: "test")));},
            child: Row(
              children: [
                const SizedBox(width: 20.0),
                recipeImage(context),
                const SizedBox(width: 20.0),
                recipeInfo(context),
                const SizedBox(width: 20.0),
                recipePlanning(context),
                const SizedBox(width: 20.0),
                predictedMeal(context),

              ],
            ),
          );
    }
    else{
      return InkWell(
        onTap : () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipePage(recipe: "test")));},
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

  Widget recipeImage(BuildContext context){
    return Card.filled(
      color: AppColors.beige,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Adds space between the image and the card's border
        child: Image(
          image: AssetImage(AppIcons.getIcon("placeholder_square")),
          width: 64,
          height: 64,
        ),
      ),
    );
  }

  Widget recipeInfo(BuildContext context ){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(recipe.toUpperCase()),
        Text("preparation ..min"),
        Text("cooking ..min")
      ],
    );
  }

  Widget recipePlanning(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("E P D",  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7),),
        Text("nb pers",  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7),),
      ],
    );
  }

  Widget predictedMeal(BuildContext context){
    return Row(
      children: [
        SvgPicture.asset(AppIcons.getIcon("sunny"),width: 32, height: 32,),
        const Padding(padding: EdgeInsets.all(5.0)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("day".toUpperCase(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7),),
            Text("time", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7),),
          ],
        )
      ],
    );
  }
}
