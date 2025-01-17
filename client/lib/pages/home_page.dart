import 'package:client/custom_widgets/cooking_info.dart';
import 'package:client/custom_widgets/custom_buttons.dart';
import 'package:client/custom_widgets/custom_dividers.dart';
import 'package:client/custom_widgets/recipe_preview.dart';
import 'package:client/pages/calendar_page.dart';
import 'package:client/pages/planned_recipes_page.dart';
import 'package:client/pages/my_creations_page.dart';
import 'package:client/pages/search_page.dart';
import 'package:client/pages/user_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/recipe_card.dart';
import '../utils/app_icons.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedRecipeIndex = 0; // Track the selected recipe index

  final List<String> recipes = ["Lasagna", "Kebab", "Carbonara"]; // List of recipes

  void _onRecipeChanged(int? index) {
    if (index != null) {
      setState(() {
        _selectedRecipeIndex = index;
      });
    }
  }

  void _showNextRecipe() {
    setState(() {
      _selectedRecipeIndex = (_selectedRecipeIndex + 1) % recipes.length;
    });
  }

  void _showPreviousRecipe() {
    setState(() {
      _selectedRecipeIndex =
          (_selectedRecipeIndex - 1 + recipes.length) % recipes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      CustomButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyCreationsPage()));},
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
    return Center(
      child: Column(
        children: [
          ColorfulTextBuilder("Today", 35, true).getWidget(),
          mainRecipes(context),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CookingInfo(recipe: "lasagne", iconName: "timer",),
              CookingInfo(recipe: "lasagne", iconName: "bell",),

            ],
          ),
          CustomButton(onPressed: (){}, text: "Let's go !"),
          CustomDivider(important: true, color : AppColors.pink),
          RecipePreview(recipe: "Lasagnas",homepage: true),
          CustomDivider(),
          RecipePreview(recipe: "Kebab",homepage: true),
          CustomDivider(),
          RecipePreview(recipe: "Carbonara",homepage: true),
        ],
      ),
    );

  }

  Widget mainRecipes(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              text: "previous",
              onPressed: _showPreviousRecipe,
              color: AppColors.white,
            ),
            RecipeCard(recipe: recipes[_selectedRecipeIndex]),
            CustomButton(
              text: "next",
              onPressed: _showNextRecipe,
              color: AppColors.white,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(recipes.length, (index) {
            return Radio<int>(
              value: index,
              groupValue: _selectedRecipeIndex,
              onChanged: _onRecipeChanged,
              activeColor: AppColors.green,
            );
          }),
        ),
      ],
    );
  }

}