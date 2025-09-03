import 'package:client/core/view_model.dart';

abstract class StateViewModel extends ViewModel {
  Future<bool> isValid();
}
