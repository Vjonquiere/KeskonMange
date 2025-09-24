import 'package:client/core/widget_states.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/widgets/recipe_card.dart';
import 'package:client/features/recipe/viewmodels/recipe_viewmodel.dart';
import 'package:client/features/recipe/widgets/ingredients_list/ingredients_list.dart';
import 'package:client/features/recipe/widgets/steps_list.dart';
import 'package:client/features/recipe_planning/models/days.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/cooking_info.dart';
import '../../../core/widgets/custom_buttons.dart';

class RecipePage extends StatelessWidget {
  Widget _dateSelected(RecipeViewModel viewModel) {
    return Row(
      children: [
        Text(viewModel.selectedPlanningDate.toString().split(" ").first),
        //SegmentedButton(segments: [ButtonSegment(value: Meal.lunch, label: Text("l")), ButtonSegment(value: Meal.dinner, label: Text("d"))], selected: {Meal.lunch}),
        IconButton(
            onPressed: () {
              viewModel.addToCalendar();
              viewModel.updateSelectedDate(null);
            },
            icon: Icon(
              Icons.check,
              color: AppColors.blue,
            )),
        IconButton(
            onPressed: () {
              viewModel.updateSelectedDate(null);
            },
            icon: Icon(
              Icons.delete_forever_outlined,
              color: AppColors.red,
            ))
      ],
    );
  }

  Widget _planning(RecipeViewModel viewModel, BuildContext context) {
    if (viewModel.nextTimePlanned == null) {
      return Text("Not planned");
    } else {
      return Row(
        children: [
          Text("on ${viewModel.nextTimePlanned.toString().split(" ").first}"),
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              viewModel.calendarEntriesCount, (int index) {
                            bool isAfter = viewModel.calendarEntries
                                .elementAt(index)
                                .isAfter(DateTime.now());
                            return Row(
                              children: [
                                Text(viewModel.calendarEntries
                                    .elementAt(index)
                                    .toString()
                                    .split(" ")
                                    .first),
                                IconButton(
                                    onPressed: isAfter
                                        ? () {
                                            viewModel.removeFromCalendar(
                                                viewModel.calendarEntries
                                                    .elementAt(index));
                                            Navigator.of(context).pop();
                                          }
                                        : () {},
                                    icon: isAfter
                                        ? Icon(Icons.delete)
                                        : Icon(Icons.calendar_month))
                              ],
                            );
                          }),
                        ),
                      );
                    });
              },
              icon: Icon(
                Icons.edit_outlined,
                color: AppColors.blue,
              ))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final RecipeViewModel viewModel = Provider.of<RecipeViewModel>(context);
    return switch (viewModel.state) {
      WidgetStates.idle => CircularProgressIndicator(),
      WidgetStates.loading => CircularProgressIndicator(),
      WidgetStates.ready => Scaffold(
          floatingActionButton: CustomButton(
            iconSize: 32,
            text: "back",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: RecipeCard(recipe: viewModel.recipe.recipePreview),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CookingInfo(
                      recipe: "lasagne",
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              var result = await showDatePicker(
                                  context: context,
                                  currentDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 90)));
                              viewModel.updateSelectedDate(result);
                            },
                            icon: Icon(Icons.calendar_month)),
                        viewModel.selectedPlanningDate != null
                            ? _dateSelected(viewModel)
                            : _planning(viewModel, context),
                      ],
                    ),
                  ],
                ),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.list,
                      width: 48,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Originally made for ${viewModel.recipe.portions} persons,"),
                        Text("Adapted for x")
                      ],
                    ),
                  ],
                ),
                IngredientsList(ingredients: viewModel.recipe.ingredients),
                CustomDivider(
                  important: true,
                  color: AppColors.pink,
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.prep,
                      width: 40,
                    ),
                    Expanded(child: StepsList(steps: viewModel.recipe.steps)),
                  ],
                )),
                /*CustomDivider(
                  color: AppColors.pink,
                  important: true,
                )*/
              ],
            ),
          )),
      WidgetStates.error => CircularProgressIndicator(),
      WidgetStates.dispose => CircularProgressIndicator(),
    };
  }
}
