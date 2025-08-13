import 'package:client/features/recipe_creation/widgets/ingredient_card.dart';
import 'package:client/features/recipe_creation/widgets/ingredient_quantity.dart';
import 'package:client/features/recipe_creation/widgets/ingredient_row.dart';
import 'package:client/features/recipe_creation/widgets/step.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/data/usecases/ingredient/search_ingredient_by_name_use_case.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/features/recipe_creation/views/recipe_step_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../core/widgets/colorful_text_builder.dart';
import '../../../core/widgets/custom_buttons.dart';
import '../../../utils/app_icons.dart';
import '../../home/views/home_page.dart';
import '../../user_creations/views/my_creations_page.dart';
import 'package:client/model/recipe/step.dart' as st;

class NewRecipePage extends StatefulWidget {
  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  final _recipeNameController = TextEditingController();
  final _typeOfRecipeController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final storage = const FlutterSecureStorage();

  ListView element = ListView();
  var stateValue = 0.0;
  var step = 0;
  var nbSteps = 5;
  var signupFinalized = false;

  var _portions = 1;
  var _typeOfMeal = "";
  var _sweet = 0;
  var _salty = 0;

  List<IngredientCard> _selectedIngredients = [];
  List<IngredientCard> _searchIngredients = [];
  List<StepWidget> _steps = [];
  final TextEditingController _ingredientSearchController =
      TextEditingController();
  final SearchIngredientByNameUseCase _searchIngredientByNameUseCase =
      SearchIngredientByNameUseCase(
          RepositoriesManager().getIngredientRepository());

  void nextStep() {
    setState(() {
      step += 1;
      stateValue += 0.2;
    });
  }

  void previousStep() {
    setState(() {
      step -= 1;
      stateValue -= 0.2;
    });
  }

  double oneStep() {
    return 1 / nbSteps;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    // Use a switch statement to determine which widget to display
    switch (step) {
      case 0:
        content = createRecipeStep(context);
        break;
      case 1:
        content = addIngredientsStep(context);
        break;
      case 2:
        content = quantitiesStep(context);
        break;
      case 3:
        content = cookingStep(context);
        break;
      case 4:
        content = recapStep(context);
        break;
      default:
        content = const Center(child: Text("No more steps"));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: bottomButtons(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                ColorfulTextBuilder("Create your recipe!", 30, true)
                    .getWidget(),
              ],
            ),
            const SizedBox(height: 20.0),
            LinearPercentIndicator(
              percent: stateValue,
              lineHeight: 25,
              backgroundColor: AppColors.beige,
              progressColor: AppColors.kaki,
              barRadius: const Radius.circular(25.0),
              center: Text("${(stateValue * 100).round()}%"),
              animation: true,
              animationDuration: 1000,
              animateFromLastPercent: true,
              onAnimationEnd: () {
                if (signupFinalized) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyCreationsPage()));
                }
              },
            ),
            const SizedBox(height: 20),
            content,
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    if (step == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomButton(
              text: "GO BACK",
              onPressed: () {
                Navigator.of(context).pop(
                    MaterialPageRoute(builder: (context) => MyCreationsPage()));
              }),
          CustomButton(
              text: "NEXT",
              onPressed: () {
                nextStep();
              })
        ],
      );
    }
    if (step == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //TODO: add actions to buttons
        children: [
          CustomButton(text: "MODIFY", onPressed: () {}),
          CustomButton(
            text: "PUBLISH",
            onPressed: () {},
            color: AppColors.pink,
          ),
          CustomButton(text: "DELETE", onPressed: () {})
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
            text: "PREVIOUS",
            onPressed: () {
              previousStep();
            }),
        CustomButton(
            text: "NEXT",
            onPressed: () {
              nextStep();
            })
      ],
    );
  }

  Widget createRecipeStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        addRecipePicture(),
        recipeInfo(),
      ],
    );
  }

  void removeIngredient(Ingredient target) {
    for (IngredientCard ingredient in _selectedIngredients) {
      if (ingredient.ingredient.name == target.name) {
        setState(() {
          _selectedIngredients.remove(ingredient);
          return;
        });
      }
    }
  }

  Widget addIngredientsStep(BuildContext context) {
    if (_ingredientSearchController.text.isEmpty) {
      updateDisplayedIngredients();
    }
    return Column(
      children: [
        ColorfulTextBuilder("Add Ingredients", 25).getWidget(),
        IngredientRow(_selectedIngredients, false),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                Expanded(
                    child: TextField(
                  controller: _ingredientSearchController,
                  onChanged: (input) async {
                    updateDisplayedIngredients(name: input);
                  },
                ))
              ],
            )),
        IngredientRow(_searchIngredients, true),
      ],
    );
  }

  void updateDisplayedIngredients({String name = ""}) async {
    _searchIngredientByNameUseCase.name = name;
    var result = await _searchIngredientByNameUseCase.execute();

    setState(() {
      _searchIngredients = result.map((element) {
        return IngredientCard(element, () {
          bool alreadySelected = _selectedIngredients.any(
            (card) => card.ingredient == element,
          );
          if (!alreadySelected) {
            setState(() {
              _selectedIngredients.add(IngredientCard(
                element,
                () => {},
                () => removeIngredient(element),
                removable: true,
                backgroundColor: AppColors.blue,
              ));
            });
          }
        }, () => {});
      }).toList();
    });
  }

  List<Ingredient> ingredientsCardsToIngredients() {
    List<Ingredient> ingredients = [];
    for (IngredientCard current in _selectedIngredients) {
      ingredients.add(current.ingredient);
    }
    return ingredients;
  }

  Widget quantitiesStep(BuildContext context) {
    if (_selectedIngredients.isEmpty) return Column();
    return IngredientQuantity(ingredientsCardsToIngredients());
  }

  void addStep() async {
    st.Step? stepValue = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RecipeStepPage()));
    if (stepValue != null) {
      debugPrint(stepValue.toString());
      setState(() {
        _steps.add(StepWidget(
          stepValue,
          stepNumber: _steps.length + 1,
          key: Key("${_steps.length}"),
        ));
      });
    }
  }

  Widget cookingStep(BuildContext context) {
    return ReorderableListView(
      footer: CustomButton(
        text: "add",
        onPressed: addStep,
        scaleSize: 1.0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: _steps,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final StepWidget item = _steps.removeAt(oldIndex);
          _steps.insert(newIndex, item);
          _steps = List.generate(
            _steps.length,
            (index) => StepWidget(
              _steps[index].step,
              stepNumber: index + 1,
              key: Key("${index + 1}"),
            ),
          );
        });
      },
    );
  }

  Widget recapStep(BuildContext context) {
    return Column();
  }

  Widget addRecipePicture() {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText("What does it look like?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card.filled(
              color: AppColors.beige,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(AppIcons.getIcon("placeholder")),
                  width: imageWidth,
                ),
              ),
            ),
            Column(
              children: [
                CustomButton(
                    text: "Import", onPressed: () {}, color: AppColors.blue),
                CustomButton(
                    text: "Take a picture",
                    onPressed: () {},
                    color: AppColors.yellow),
              ],
            ),
          ],
        )
      ],
    );
  }

  Padding questionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget recipeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionText("What do we cook?"),
        userTextInput("Recipe title", _recipeNameController),
        const SizedBox(height: 16), // Add spacing
        nbOfPplFed(),
        kindOfRecipe(),
        cookingTime(),
      ],
    );
  }

  Widget nbOfPplFed() {
    return Column(
      children: [
        questionText("How many persons does it feed?"),
        Wrap(
          spacing: 10.0, // Space between radio buttons
          children: List.generate(10, (index) {
            int value = index + 1;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: value,
                  groupValue: _portions,
                  activeColor: AppColors.pink,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _portions = newValue;
                      });
                    }
                  },
                ),
                Text(value.toString()),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget kindOfRecipe() {
    return Column(
      children: [
        questionText("What type of recipe is it?"),
        Wrap(
          spacing: 20.0, // Space between radio buttons
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: "Starter",
                  groupValue: _typeOfMeal,
                  activeColor: AppColors.pink,
                  onChanged: (String? newValue) {
                    setState(() {
                      _typeOfMeal = newValue!;
                    });
                  },
                ),
                const Text("Starter"),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: "Main Course",
                  groupValue: _typeOfMeal,
                  activeColor: AppColors.pink,
                  onChanged: (String? newValue) {
                    setState(() {
                      _typeOfMeal = newValue!;
                    });
                  },
                ),
                const Text("Main Course"),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: "Dessert",
                  groupValue: _typeOfMeal,
                  activeColor: AppColors.pink,
                  onChanged: (String? newValue) {
                    setState(() {
                      _typeOfMeal = newValue!;
                    });
                  },
                ),
                const Text("Dessert"),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: "Other",
                  groupValue: _typeOfMeal,
                  activeColor: AppColors.pink,
                  onChanged: (String? newValue) {
                    setState(() {
                      _typeOfMeal = newValue!;
                    });
                  },
                ),
                const Text("Other:"),
                const SizedBox(width: 10), // Space between radio and input
                SizedBox(
                  width: 120, // Adjust width for input
                  child: TextField(
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.yellow), // Yellow underline
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.pink), // Orange when focused
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _typeOfMeal = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  TextField userTextInput(String input, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: input,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.yellow), // Yellow underline
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.pink), // Orange when focused
        ),
      ),
    );
  }

  Widget cookingTime() {
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.getIcon("timer"),
          width: 48,
          height: 48,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Preparation time in minutes\t",
                    )),
                SizedBox(
                  width: 50,
                  child: userTextInput("", _preparationTimeController),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Cooking time in minutes\t",
                    )),
                SizedBox(
                  width: 50,
                  child: userTextInput("", _cookingTimeController),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
