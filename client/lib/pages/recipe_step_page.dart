import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class RecipeStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeStep();
  }
}

class RecipeStep extends State<RecipeStepPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New recipe step"),
      ),
      body: Column(
        children: [
          TextField(),
          const Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Write your recipe step...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.blue,
                    width: 10.0,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.orange,
                    width: 5.0,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.blue,
                    width: 6.0,
                  )),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => {},
                      icon: Icon(
                        Icons.close,
                        color: AppColors.orange,
                      )),
                  IconButton(
                      onPressed: () => {},
                      icon: Icon(
                        Icons.check,
                        color: AppColors.green,
                      )),
                ]),
          )
        ],
      ),
    );
  }
}
