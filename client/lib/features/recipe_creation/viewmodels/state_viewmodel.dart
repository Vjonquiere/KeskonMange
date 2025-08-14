import 'package:client/core/ViewModel.dart';
import 'package:flutter/cupertino.dart';

abstract class StateViewModel extends ViewModel {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool isValid();

  @protected
  void setErrorMessage(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
