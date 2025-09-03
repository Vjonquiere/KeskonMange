import 'package:client/core/widget_states.dart';
import 'package:flutter/cupertino.dart';

abstract class ViewModel extends ChangeNotifier {
  WidgetStates _state = WidgetStates.idle;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  WidgetStates get state => _state;

  @protected
  void setStateValue(WidgetStates newState) {
    _state = newState;
  }

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
