import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IngredientCard extends StatelessWidget {
  final String name;
  final VoidCallback _removeCallback;
  final VoidCallback _onClickCallback;
  final removable;
  final Color backgroundColor;

  IngredientCard(this.name, this._onClickCallback, this._removeCallback,
      {super.key,
      this.removable = false,
      this.backgroundColor = AppColors.yellow});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _onClickCallback,
          child: Card.filled(
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),

            //margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0 ),
            color: backgroundColor,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(name),
            ),
          ),
        ),
        if (removable)
          Positioned(
              right: 0,
              top: -5,
              child: InkWell(
                onTap: _removeCallback,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.orange),

                  //alignment: Alignment.topLeft,
                  child: Text("x"),
                ),
              ))
      ],
    );
  }
}
