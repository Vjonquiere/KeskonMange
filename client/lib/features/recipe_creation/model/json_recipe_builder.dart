import 'package:client/features/recipe_creation/model/recipe_builder.dart';
import 'package:client/model/ingredient.dart';
import 'package:client/model/recipe/step.dart';

class JsonRecipeBuilder extends RecipeBuilder {
  String _recipe = "{";

  @override
  void addIngredients(List<Ingredient> ingredients) {
    String ingredientsString = "";
    for (Ingredient ingredient in ingredients) {
      ingredientsString += "${ingredient.id},";
    }
    _recipe +=
        '"ingredients": [${ingredientsString.substring(0, ingredientsString.length - 1)}],';
  }

  @override
  void addSteps(List<Step> steps) {
    String stepsString = "";
    for (Step step in steps) {
      stepsString +=
          '{"title": "${step.title}", "stepText": "${step.stepText}"},';
    }
    _recipe +=
        '"steps": [${stepsString.substring(0, stepsString.length - 1)}],';
  }

  @override
  void setCookTime(int cookTime) {
    _recipe += '"cookTime": "$cookTime",';
  }

  @override
  void setCost(int cost) {
    _recipe += '"cost": "$cost",';
  }

  @override
  void setDifficulty(int difficulty) {
    _recipe += '"difficulty": "$difficulty",';
  }

  @override
  void setHasGluten(int hasGluten) {
    _recipe += '"hasGluten": "$hasGluten",';
  }

  @override
  void setHasLactose(int hasLactose) {
    _recipe += '"hasLactose": "$hasLactose",';
  }

  @override
  void setHasPork(int hasPork) {
    _recipe += '"hasPork": "$hasPork",';
  }

  @override
  void setPreparationTime(int preparationTime) {
    _recipe += '"preparationTime": "$preparationTime",';
  }

  @override
  void setPublic(int public) {
    _recipe += '"public": "$public",';
  }

  @override
  void setRestTime(int restTime) {
    _recipe += '"restTime": "$restTime",';
  }

  @override
  void setSalty(int salty) {
    _recipe += '"salty": "$salty",';
  }

  @override
  void setSweet(int sweet) {
    _recipe += '"sweet": "$sweet",';
  }

  @override
  void setTitle(String title) {
    _recipe += '"title": "$title",';
  }

  @override
  void setType(String type) {
    _recipe += '"type": "$type",';
  }

  @override
  void setVegan(int vegan) {
    _recipe += '"vegan": "$vegan",';
  }

  @override
  void setVegetarian(int vegetarian) {
    _recipe += '"vegetarian": "$vegetarian",';
  }

  String getResult() {
    return "${_recipe.substring(0, _recipe.length - 1)}}";
  }
}
