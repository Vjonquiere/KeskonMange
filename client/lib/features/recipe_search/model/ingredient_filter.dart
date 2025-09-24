import 'package:client/features/recipe_search/model/filters.dart';
import 'package:client/model/ingredient.dart';

class IngredientFilter extends Filter {
  List<Ingredient> ingredients;

  IngredientFilter({required this.ingredients});

  @override
  String toJson() {
    String result = "";
    result += '{"ingredients":[';
    for (Ingredient ingredient in ingredients) {
      result += '"${ingredient.name}",';
    }
    result.substring(0, result.length - 1);
    result += "]}";
    return result;
  }
}
