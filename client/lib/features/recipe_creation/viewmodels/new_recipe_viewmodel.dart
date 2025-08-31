import 'package:client/core/ViewModel.dart';
import 'package:client/features/recipe_creation/viewmodels/ingredient_quantities_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/recipe_review_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/recipe_step_viewmodel.dart';
import 'package:client/core/state_viewmodel.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/model/recipe/recipe.dart';
import 'general_information_viewmodel.dart';
import 'ingredients_viewmodel.dart';

class NewRecipeViewModel extends ViewModel {
  final IngredientsViewModel _ingredientsViewModel = IngredientsViewModel();
  final IngredientQuantitiesViewModel _ingredientQuantitiesViewModel =
      IngredientQuantitiesViewModel();
  final RecipeReviewViewModel _recipeReviewViewModel = RecipeReviewViewModel();
  final GeneralInformationViewModel _generalInformationViewModel =
      GeneralInformationViewModel();
  final RecipeStepViewModel _recipeStepViewModel = RecipeStepViewModel();
  int _currentIndex = 0;
  double _progressBarValue = 0.0;

  late final List<StateViewModel> _steps = [
    _generalInformationViewModel,
    _ingredientsViewModel,
    _ingredientQuantitiesViewModel,
    _recipeStepViewModel,
    _recipeReviewViewModel
  ];

  int get currentStep => _currentIndex;
  StateViewModel get currentStepViewModel => _steps[_currentIndex];
  double get progressBarValue => _progressBarValue;

  void nextStep() async {
    if (await (_steps[_currentIndex].isValid())) {
      if (_currentIndex == 1) {
        _ingredientQuantitiesViewModel.setIngredients(
            _ingredientsViewModel.getSelectedIngredientsClone());
      }
      if (_currentIndex == 3) {
        _recipeReviewViewModel.setRecipe(Recipe(
            RecipePreview(
                -1,
                _generalInformationViewModel.recipeTitleController.text,
                _generalInformationViewModel.typeOfMeal,
                0,
                1,
                1,
                1,
                0,
                0,
                0,
                1,
                0,
                20,
                16,
                20,
                -1,
                1),
            _ingredientQuantitiesViewModel.values,
            _generalInformationViewModel.portions,
            _recipeStepViewModel.steps));
      }
      _currentIndex++;
      _progressBarValue = _currentIndex / _steps.length;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _progressBarValue = _currentIndex / _steps.length;
      notifyListeners();
    }
  }
}
