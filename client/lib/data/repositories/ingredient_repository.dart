import 'package:client/model/ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> findByNameLike(String name);
  Future<int> createIngredient(Ingredient ingredient);
}
