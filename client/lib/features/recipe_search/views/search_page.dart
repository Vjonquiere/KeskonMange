import 'dart:ffi';

import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/data/usecases/recipe/get_recipe_from_id_use_case.dart';
import 'package:client/data/usecases/recipes/get_last_recipes_ids_use_case.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/widgets/search/Recipe.dart';
import 'package:client/widgets/search/TopBar.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../widgets/search/Filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<int>> recipesIds;

  @override
  void initState() {
    recipesIds =
        GetLastRecipesUseCase(RepositoriesManager().getRecipeRepository(), 10)
            .execute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              const TopBar(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              const Filter(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FutureBuilder<List<int>>(
                  future: recipesIds,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasData) {
                      List<int> ids = snapshot.requireData;
                      if (ids.isEmpty) {
                        return const Text("No recipes found");
                      }
                      return ListView.builder(
                          itemCount: ids.length,
                          itemBuilder: (context, index) {
                            Future<RecipePreview?> res = GetRecipeFromIdUseCase(
                                    RepositoriesManager().getRecipeRepository(),
                                    ids[index])
                                .execute();
                            return FutureBuilder<RecipePreview?>(
                                future: res,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.requireData != null) {
                                    return Recipe(
                                        snapshot.requireData!.title,
                                        "",
                                        snapshot.requireData!.preparationTime,
                                        snapshot.requireData!.cookTime);
                                  } else if (snapshot.hasError) {
                                  } else {}
                                  return Text("Something went wrong");
                                });
                          });

                      return const Text("");
                    } else if (snapshot.hasError) {
                      return const Text("Something went wrong, try to reload");
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ]),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'back',
            ),
          ],
        ),
      ),
    );
  }
}
