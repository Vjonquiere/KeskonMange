import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import 'package:client/model/recipe/step.dart' as st;

class RecipeStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeStep();
  }
}

class RecipeStep extends State<RecipeStepPage> {
  TextEditingController _stepController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New recipe step"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _stepController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
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
                      onPressed: () => {Navigator.of(context).pop()},
                      icon: Icon(
                        Icons.close,
                        color: AppColors.orange,
                      )),
                  IconButton(
                      onPressed: () => {
                            Navigator.of(context).pop(st.Step(
                                _titleController.text, _stepController.text))
                          },
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
