import 'package:client/data/repositories/ingredient_repository.dart';
import 'package:client/model/ingredient.dart';

class IngredientRepositoryMock extends IngredientRepository {
  final List<Ingredient> _ingredients = <Ingredient>[];
  int _nextId = 0;

  @override
  Future<int> createIngredient(Ingredient ingredient) async {
    _nextId++;
    _ingredients
        .add(Ingredient.withId(_nextId, ingredient.name, ingredient.type));
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

  @override
  Future<Ingredient?> getIngredientFromId(int id) async {
    for (Ingredient ingredient in _ingredients) {
      if (ingredient.id == id) {
        return ingredient;
      }
    }
    return null;
  }
}
