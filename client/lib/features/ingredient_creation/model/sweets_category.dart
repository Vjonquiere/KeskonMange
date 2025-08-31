import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class SweetsCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return <String>["sweet drinks", "syrup", "cake"];
  }

  @override
  String toString() {
    return "sweets";
  }
}
