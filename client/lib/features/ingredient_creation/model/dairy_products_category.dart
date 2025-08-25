import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class DairyProductsCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return [];
  }

  @override
  String toString() {
    return "dairy products";
  }
}
