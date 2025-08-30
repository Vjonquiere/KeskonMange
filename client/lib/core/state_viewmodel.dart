import 'package:client/core/ViewModel.dart';
import 'package:flutter/cupertino.dart';

abstract class StateViewModel extends ViewModel {
  Future<bool> isValid();
}
