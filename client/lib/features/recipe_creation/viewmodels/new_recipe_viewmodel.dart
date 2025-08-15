import 'package:client/core/ViewModel.dart';
import 'package:client/features/recipe_creation/viewmodels/ingredient_quantities_viewmodel.dart';
import 'package:client/features/recipe_creation/viewmodels/recipe_step_viewmodel.dart';
import 'package:client/core/state_viewmodel.dart';
import '../model/creation_steps.dart';
import 'general_information_viewmodel.dart';
import 'ingredients_viewmodel.dart';

class NewRecipeViewModel extends ViewModel {
  //late StateViewModel _currentStepViewModel = _generalInformationViewModel;
  IngredientsViewModel _ingredientsViewModel = IngredientsViewModel();
  IngredientQuantitiesViewModel _ingredientQuantitiesViewModel =
      IngredientQuantitiesViewModel();
  int _currentIndex = 0;
  double _progressBarValue = 0.0;

  late final List<StateViewModel> _steps = [
    GeneralInformationViewModel(),
    _ingredientsViewModel,
    _ingredientQuantitiesViewModel,
    RecipeStepViewModel(),
  ];

  int get currentStep => _currentIndex;
  StateViewModel get currentStepViewModel => _steps[_currentIndex];
  double get progressBarValue => _progressBarValue;

  void nextStep() async {
    if (await (_steps[_currentIndex].isValid())) {
      if (_currentIndex == 1)
        _ingredientQuantitiesViewModel.setIngredients(
            _ingredientsViewModel.getSelectedIngredientsClone());
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
