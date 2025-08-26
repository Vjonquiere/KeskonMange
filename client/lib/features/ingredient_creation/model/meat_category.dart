import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class MeatCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return ["meat", "fish", "egg"];
  }

  @override
  String toString() {
    return "meat";
  }
}
