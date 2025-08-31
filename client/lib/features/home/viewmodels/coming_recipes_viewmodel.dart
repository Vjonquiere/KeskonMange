import 'package:client/model/recipe/preview.dart';

import '../../../core/ViewModel.dart';
import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/get_recipe_from_id_use_case.dart';

class ComingRecipesViewModel extends ViewModel {
  List<RecipePreview> _recipes = <RecipePreview>[];

  List<RecipePreview> get recipes => _recipes;

  ComingRecipesViewModel() {
    getRecipes();
  }

  Future<void> getRecipes() async {
    //recipes = await RepositoriesManager().getCalendarRepository().getNextPlannedRecipes(3);
    final List<int> ids = <int>[1, 2, 3];
    final List<RecipePreview> recipes = <RecipePreview>[];
    for (int id = 0; id < ids.length; id++) {
      final RecipePreview? recipe = await GetRecipeFromIdUseCase(
              RepositoriesManager().getRecipeRepository(), ids[id],)
          .execute();
      if (recipe != null) recipes.add(recipe);
    }
    _recipes = recipes;
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }
}
