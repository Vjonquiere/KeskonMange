import 'package:client/features/ingredient_creation/model/Ingredient_category.dart';

class CerealStarchesCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return ["cereal", "starches"];
  }

  @override
  String toString() {
    return "cereal/starches";
  }
}
