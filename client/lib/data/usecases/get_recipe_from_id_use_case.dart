import 'package:client/data/repositories/recipe_repository.dart';

import '../../model/recipe/preview.dart';

class GetRecipeFromIdUseCase {
  final RecipeRepository _recipeRepository;
  int recipeId;

  GetRecipeFromIdUseCase(this._recipeRepository, this.recipeId);

  Future<RecipePreview?> execute() {
    return _recipeRepository.getRecipeFromId(recipeId);
  }
}
