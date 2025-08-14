import 'package:client/core/widget_states.dart';
import 'package:flutter/cupertino.dart';

abstract class ViewModel extends ChangeNotifier {
  WidgetStates _state = WidgetStates.idle;

  WidgetStates get state => _state;

  @protected
  void setStateValue(WidgetStates newState) {
    _state = newState;
  }
}
