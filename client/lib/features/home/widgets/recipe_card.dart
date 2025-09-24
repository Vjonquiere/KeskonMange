import 'dart:math';

import 'package:client/model/recipe/preview.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/app_icons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class RecipeCard extends StatelessWidget {
  final RecipePreview recipe;

  const RecipeCard({
    required this.recipe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppColors.beige,
        margin: const EdgeInsets.all(8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //TODO: add the icons according to the recipe
                      SvgPicture.asset(
                        AppIcons.getIcon("veggie"),
                        width: 32,
                        height: 32,
                      ),
                      SvgPicture.asset(
                        AppIcons.getIcon("meal"),
                        width: 32,
                        height: 32,
                      ),
                      SvgPicture.asset(
                        AppIcons.getIcon("cake"),
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                )),
            Padding(
                padding: const EdgeInsetsGeometry.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: recipe.image == null
                          ? Image(
                              image: AssetImage(
                                  AppIcons.getIcon("placeholder_square")),
                              //width: imageWidth,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              recipe.image!,
                              //width: min(imageWidth, 128),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                        width: 200,
                        child: Text(
                          recipe.title,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        )),
                  ],
                ))
          ],
        )));
  }
}
