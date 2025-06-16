import 'package:client/custom_widgets/cooking_info.dart';
import 'package:client/custom_widgets/custom_buttons.dart';
import 'package:client/custom_widgets/custom_dividers.dart';
import 'package:client/http/recipe/GetRecipeFromIdRequest.dart';
import 'package:client/pages/calendar_page.dart';
import 'package:client/pages/planned_recipes_page.dart';
import 'package:client/pages/my_creations_page.dart';
import 'package:client/pages/search_page.dart';
import 'package:client/pages/user_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/custom_widgets/recipe_preview.dart' as rpView;

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/recipe_card.dart';
import '../model/recipe/preview.dart';
import '../utils/app_icons.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedRecipeIndex = 0; // Track the selected recipe index
  late Future<List<RecipePreview?>> recipes; // List of recipes

  @override
  void initState() {
    super.initState();
    recipes = getRecipes([1, 2, 1]);
  }

  void _onRecipeChanged(int? index) {
    if (index != null) {
      setState(() {
        _selectedRecipeIndex = index;
      });
    }
  }

  Future<RecipePreview?> getRecipe(int id) async {
    var recipe = GetRecipeRequest(id.toString());
    if ((await recipe.send()) == 200) {
      return recipe.getRecipe()!;
    }
    return null;
  }

  Future<List<RecipePreview?>> getRecipes(List<int> ids) async {
    List<RecipePreview?> recipes = [];
    for (var id = 0; id < ids.length; id++) {
      recipes.add(await getRecipe(ids[id]));
    }
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: AppColors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserPage()));
                  },
                  text: 'pen'),
              CustomButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyCreationsPage()));
                  },
                  text: 'book'),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: SvgPicture.asset(AppIcons.getIcon('search')),
              ),
              CustomButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlannedRecipesPage()));
                  },
                  text: 'upload'),
              CustomButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CalendarPage()));
                  },
                  text: 'calendar'),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              home(context),
            ],
          ),
        ));
  }

  Widget home(context) {
    return Center(
      child: Column(
        children: [
          ColorfulTextBuilder("Today", 35, true).getWidget(),
          mainRecipes(context),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CookingInfo(
                recipe: "lasagne",
                iconName: "timer",
              ),
              CookingInfo(
                recipe: "lasagne",
                iconName: "bell",
              ),
            ],
          ),
          CustomButton(onPressed: () {}, text: "Let's go !"),
          const CustomDivider(important: true, color: AppColors.pink),
          FutureBuilder<List<RecipePreview?>>(
              future: recipes,
              builder: (BuildContext context,
                  AsyncSnapshot<List<RecipePreview?>> snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData) {
                  var length = snapshot.data?.length;
                  for (var i = 0; i < length!; i++) {
                    final preview = snapshot.data![i];
                    if (preview != null) {
                      children.add(rpView.RecipePreview(
                        recipe: preview,
                        homepage: true,
                      ));
                    }

                    children.add(const CustomDivider());
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }

  Widget mainRecipes(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<RecipePreview?>>(
            future: recipes,
            builder: (BuildContext context,
                AsyncSnapshot<List<RecipePreview?>> snapshot) {
              List<Widget> children = [];

              if (snapshot.hasData) {
                var length = snapshot.data?.length;
                final recipe = snapshot.data![_selectedRecipeIndex];
                if (recipe == null) return Container();
                children.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: "previous",
                      onPressed: () {
                        setState(() {
                          _selectedRecipeIndex =
                              (_selectedRecipeIndex - 1 + length!) % length;
                        });
                      },
                      color: AppColors.white,
                    ),
                    RecipeCard(recipe: recipe),
                    CustomButton(
                      text: "next",
                      onPressed: () {
                        setState(() {
                          _selectedRecipeIndex =
                              (_selectedRecipeIndex + 1) % length!;
                        });
                      },
                      color: AppColors.white,
                    ),
                  ],
                ));
                children.add(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(length!, (index) {
                      return Radio<int>(
                        value: index,
                        groupValue: _selectedRecipeIndex,
                        onChanged: _onRecipeChanged,
                        activeColor: AppColors.green,
                      );
                    }),
                  ),
                );
                return Center(
                  child: Column(children: children),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const CircularProgressIndicator();
              }
            }),
        //
      ],
    );
  }
}
