import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/cupertino.dart';

class GeneralInformationViewModel extends StateViewModel {
  int _portions = 1;
  String _typeOfMeal = "";
  final TextEditingController _recipeTitleController = TextEditingController();
  int _preparationTime = 10;
  int _cookingTime = 15;

  int get portions => _portions;
  String get typeOfMeal => _typeOfMeal;
  TextEditingController get recipeTitleController => _recipeTitleController;
  int get preparationTime => _preparationTime;
  int get cookingTime => _cookingTime;

  void setPortions(int portions) {
    _portions = portions;
    notifyListeners();
  }

  void setPreparationTime(int newPreparationTime) {
    _preparationTime = newPreparationTime;
    notifyListeners();
  }

  void setCookingTime(int newCookingTime) {
    _cookingTime = newCookingTime;
    notifyListeners();
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
