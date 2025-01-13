import 'package:client/custom_widgets/cooking_info.dart';
import 'package:client/custom_widgets/custom_buttons.dart';
import 'package:client/custom_widgets/custom_dividers.dart';
import 'package:client/custom_widgets/recipe_preview.dart';
import 'package:client/pages/calendar_page.dart';
import 'package:client/pages/planned_recipes_page.dart';
import 'package:client/pages/recipe_books_page.dart';
import 'package:client/pages/search_page.dart';
import 'package:client/pages/user_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../utils/app_icons.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
            child: Column(
              children: [
                Expanded(child: home(context)),
                SafeArea(
                  child: BottomAppBar(
                    color : AppColors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      CustomButton(
                          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));},
                          text: 'pen'),
                      CustomButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeBooksPage()));},
                          text: 'book'
                      ),
                      FloatingActionButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));}, child: SvgPicture.asset(AppIcons.getIcon('search')),),
                      CustomButton(
                          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlannedRecipesPage()));},
                          text: 'upload'),
                      CustomButton(
                          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage()));},
                          text: 'calendar'),
                    ],),
                  ),
                )
              ],
            ))
      );
  }

  Widget home(context){
    return Column(

      children: [
        ColorfulTextBuilder("Aujourd'hui", 35, true).getWidget(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CookingInfo(recipe: "lasagne", iconName: "timer",),
            CookingInfo(recipe: "lasagne", iconName: "bell",),

          ],
        ),
        CustomButton(onPressed: (){}, text: "Let's go !"),
        CustomDivider(important: true, color : AppColors.pink),
        RecipePreview(recipe: "Lasagnes",homepage: true),
        CustomDivider(),
        RecipePreview(recipe: "Kebab",homepage: true),
        CustomDivider(),
        RecipePreview(recipe: "Carbonara",homepage: true),
      ],
    );
  }
}