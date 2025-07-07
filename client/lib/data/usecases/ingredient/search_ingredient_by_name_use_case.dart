import 'package:client/data/repositories/ingredient_repository.dart';
import 'package:client/model/ingredient.dart';

class SearchIngredientByNameUseCase {
  final IngredientRepository _ingredientRepository;
  String name;

  SearchIngredientByNameUseCase(this._ingredientRepository, {this.name = ""});

  Future<List<Ingredient>> execute() {
    return _ingredientRepository.findByNameLike(name.toLowerCase());
  }
}
