import 'package:client/data/repositories/recipe_repository.dart';

import '../../model/recipe/preview.dart';

class GetRecipeFromIdUseCase {
  RecipeRepository recipeRepository;
  int recipeId;

  GetRecipeFromIdUseCase(this.recipeRepository, this.recipeId);

  Future<RecipePreview?> execute() {
    return recipeRepository.getRecipeFromId(recipeId);
  }
}
