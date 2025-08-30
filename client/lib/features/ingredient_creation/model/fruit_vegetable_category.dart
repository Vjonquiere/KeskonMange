import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class FruitVegetableCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return ["fruit", "vegetable"];
  }

  @override
  String toString() {
    return "fruit/vegetable";
  }
}
