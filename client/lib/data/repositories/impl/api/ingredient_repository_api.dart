import 'package:client/data/repositories/ingredient_repository.dart';
import 'package:client/model/ingredient.dart';

class IngredientRepositoryApi extends IngredientRepository {
  @override
  Future<int> createIngredient(Ingredient ingredient) {
    // TODO: implement createIngredient
    throw UnimplementedError();
  }

  @override
  Future<List<Ingredient>> findByNameLike(String name) {
    // TODO: implement findByNameLike
    throw UnimplementedError();
  }

  @override
  Future<Ingredient?> getIngredientFromId(int id) {
    // TODO: implement getIngredientFromId
    throw UnimplementedError();
  }
}
