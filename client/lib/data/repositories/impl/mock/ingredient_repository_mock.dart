import 'package:client/data/repositories/ingredient_repository.dart';
import 'package:client/model/ingredient.dart';

class IngredientRepositoryMock extends IngredientRepository {
  final List<Ingredient> _ingredients = <Ingredient>[];

  @override
  Future<int> createIngredient(Ingredient ingredient) async {
    _ingredients.add(ingredient);
    return 200;
  }

  @override
  Future<List<Ingredient>> findByNameLike(String name) async {
    final List<Ingredient> matchingIngredients = <Ingredient>[];
    for (Ingredient ingredient in _ingredients) {
      if (ingredient.name.startsWith(name)) {
        matchingIngredients.add(ingredient);
      }
    }
    return matchingIngredients;
  }
}
