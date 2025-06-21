import 'dart:ffi';

import 'package:client/custom_widgets/custom_buttons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/widgets/search/Recipe.dart';
import 'package:client/widgets/search/TopBar.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../http/recipe/GetLastRecipesRequest.dart';
import '../http/recipe/GetRecipeFromIdRequest.dart';
import '../widgets/search/Filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GetLastRecipesRequest request = GetLastRecipesRequest();
  late Future<int> responseCode;

  @override
  void initState() {
    responseCode = request.send();
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
              FutureBuilder<int>(
                  future: responseCode,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    //List<Widget> recipes = [];
                    if (snapshot.hasData) {
                      if (snapshot.data == 200) {
                        var recipeIds = request.ids();
                        if (recipeIds.isEmpty) {
                          return const Text("No recipes found");
                        }
                        return ListView.builder(
                            itemCount: recipeIds.length,
                            itemBuilder: (context, index) {
                              var req =
                                  GetRecipeRequest(recipeIds[index].toString());
                              Future<int> res = req.send();
                              return FutureBuilder<int>(
                                  future: res,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var recipeData = req.getRecipe();
                                      if (recipeData != null) {
                                        return Recipe(
                                            recipeData.title, "", 15, 14);
                                      }
                                    } else if (snapshot.hasError) {
                                    } else {}
                                    return Text("Something went wrong");
                                  });
                            });
                      }
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
