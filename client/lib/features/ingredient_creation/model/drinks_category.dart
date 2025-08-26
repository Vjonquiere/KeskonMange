import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class DrinksCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return ["sweet drinks", "alcohol"];
  }

  @override
  String toString() {
    return "drinks";
  }
}
