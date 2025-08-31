import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class FatCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return <String>["oil", "butter", "cream"];
  }

  @override
  String toString() {
    return "fat";
  }
}
