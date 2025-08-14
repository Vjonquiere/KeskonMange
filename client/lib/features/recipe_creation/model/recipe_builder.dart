import 'package:client/model/ingredient.dart';

import '../../../model/recipe/step.dart';

abstract class RecipeBuilder {
  void setTitle(String title);
  void setType(String type);
  void setDifficulty(int difficulty);
  void setCost(int cost);
  void setVegetarian(int vegetarian);
  void setVegan(int vegan);
  void setHasGluten(int hasGluten);
  void setHasLactose(int hasLactose);
  void setHasPork(int hasPork);
  void setSalty(int salty);
  void setSweet(int sweet);
  void setPreparationTime(int preparationTime);
  void setRestTime(int restTime);
  void setCookTime(int cookTime);
  void setPublic(int public);
  void addIngredients(List<Ingredient> ingredients);
  void addSteps(List<Step> steps);
}
