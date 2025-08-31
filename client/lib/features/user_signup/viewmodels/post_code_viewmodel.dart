import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/cupertino.dart';

class PostCodeViewModel extends StateViewModel {
  final TextEditingController _postcodeController = TextEditingController();

  TextEditingController get postcodeController => _postcodeController;

  @override
  Future<bool> isValid() async {
    if (_postcodeController.text == "") return false;
    return true;
  }
}
