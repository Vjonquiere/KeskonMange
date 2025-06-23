import 'package:client/data/repositories/recipe_repository.dart';
import 'package:client/model/recipe/preview.dart';

class GetRecipeFromIdUseCase {
  final RecipeRepository _recipeRepository;
  int _id;

  GetRecipeFromIdUseCase(this._recipeRepository, this._id);

  Future<RecipePreview?> execute() async {
    return _recipeRepository.getRecipeFromId(_id);
  }
}
