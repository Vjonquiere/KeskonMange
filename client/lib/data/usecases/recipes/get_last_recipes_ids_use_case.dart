import 'package:client/data/repositories/recipe_repository.dart';

class GetLastRecipesUseCase {
  final RecipeRepository _recipeRepository;
  int count;

  GetLastRecipesUseCase(this._recipeRepository, this.count);

  Future<List<int>> execute() async {
    return _recipeRepository.getLastRecipesIds(count);
  }
}
