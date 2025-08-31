import 'package:client/core/ViewModel.dart';

abstract class StateViewModel extends ViewModel {
  Future<bool> isValid();
}
