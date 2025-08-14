import 'package:client/features/recipe_creation/viewmodels/state_viewmodel.dart';
import 'package:client/model/recipe/step.dart';

class RecipeStepViewModel extends StateViewModel {
  List<Step> _steps = [];

  List<Step> get steps => _steps;

  void addStep(Step step) {
    _steps.add(step);
    notifyListeners();
  }

  void reorderSteps(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Step item = _steps.removeAt(oldIndex);
    _steps.insert(newIndex, item);
    notifyListeners();
  }

  @override
  bool isValid() {
    return true;
  }
}
