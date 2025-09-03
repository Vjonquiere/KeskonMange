import 'package:client/features/ingredient_creation/model/ingredient_category.dart';

class CerealStarchesCategory implements IngredientCategory {
  @override
  List<String> getSubCategories() {
    return <String>["cereal", "starches"];
  }

  @override
  String toString() {
    return "cereal/starches";
  }
}
