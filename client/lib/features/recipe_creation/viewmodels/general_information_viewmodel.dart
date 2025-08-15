import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/cupertino.dart';

class GeneralInformationViewModel extends StateViewModel {
  int _portions = 1;
  String _typeOfMeal = "";
  final TextEditingController _recipeTitleController = TextEditingController();
  final TextEditingController _preparationTimeController =
      TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();

  int get portions => _portions;
  String get typeOfMeal => _typeOfMeal;
  TextEditingController get recipeTitleController => _recipeTitleController;
  TextEditingController get preparationTimeController =>
      _preparationTimeController;
  TextEditingController get cookingTimeController => _cookingTimeController;

  void setPortions(int? portions) {
    if (portions != null) {
      _portions = portions;
      notifyListeners();
    }
  }

  void setMealType(String? typeOfMeal) {
    if (typeOfMeal != null) {
      _typeOfMeal = typeOfMeal;
      notifyListeners();
    }
  }

  @override
  Future<bool> isValid() async {
    return true;
  }
}
