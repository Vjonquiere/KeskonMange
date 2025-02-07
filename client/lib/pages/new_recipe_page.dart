import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/custom_buttons.dart';
import '../utils/app_icons.dart';
import 'home_page.dart';
import 'my_creations_page.dart';

class NewRecipePage extends StatefulWidget {
  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  final _recipeNameController = TextEditingController();
  final _typeOfRecipeController = TextEditingController();
  final _postcodeController = TextEditingController();
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

  void nextStep() {
    setState(() {
      step += 1;
    });
  }

  void previousStep() {
    setState(() {
      step -= 1;
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

  Widget createRecipeStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        addRecipePicture(),
        recipeInfo(),
      ],
    );
  }

  Widget addIngredientsStep(BuildContext context) {
    return Column();
  }

  Widget quantitiesStep(BuildContext context) {
    return Column();
  }

  Widget cookingStep(BuildContext context) {
    return Column();
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
}
