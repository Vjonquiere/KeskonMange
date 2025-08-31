import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class Recipe extends StatelessWidget {
  final String _recipeName;
  final String _imageUrl;
  final int _preparationTime;
  final int _cookingTime;

  const Recipe(this._recipeName, this._imageUrl, this._preparationTime,
      this._cookingTime,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          //const Padding(padding: EdgeInsets.symmetric(horizontal: 10) ),
          Card.filled(
            color: AppColors.beige,
            elevation: 2,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image(
                    image: AssetImage(AppIcons.getIcon("placeholder_square")),
                    width: 64,
                    height: 64,
                  ),
                )),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_recipeName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start),
              Text("Preparation $_preparationTime min",
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.start),
              Text("Cuisson $_cookingTime min",
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.start)
            ],
          )
        ],
      ),
    );
  }
}
