import 'package:client/features/ingredient_creation/model/ingredient_category.dart';

class DrinksCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return <String>["sweet drinks", "alcohol"];
  }

  @override
  String toString() {
    return "drinks";
  }
}
