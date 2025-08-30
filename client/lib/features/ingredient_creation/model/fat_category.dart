import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class FatCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return ["oil", "butter", "cream"];
  }

  @override
  String toString() {
    return "fat";
  }
}
