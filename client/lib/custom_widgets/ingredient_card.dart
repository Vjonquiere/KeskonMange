import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IngredientCard extends StatelessWidget {
  final String _name;

  IngredientCard(this._name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card.filled(
          shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),

          //margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0 ),
          color: AppColors.blue,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(_name),
          ),
        ),
        Positioned(
            right: 0,
            top: -5,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.orange),

              //alignment: Alignment.topLeft,
              child: Text("x"),
            ))
      ],
    );
  }
}
