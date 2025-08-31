import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/signup/activate_account_use_case.dart';
import '../../../data/usecases/signup/create_account_use_case.dart';
import '../../../http/authentication.dart';
import '../../../model/user.dart';

class AccountVerificationViewModel extends StateViewModel {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  late User _user;

  TextEditingController get verificationCodeController =>
      _verificationCodeController;

  @override
  Future<bool> isValid() async {
    if (_verificationCodeController.text == "") return false;
    final ActivateUserUseCase activation = ActivateUserUseCase(
      RepositoriesManager().getUserRepository(),
      _user.email,
      _verificationCodeController.text,
    );
    final String? apiKey = await activation.execute();
    if (apiKey == null) {
      setStateValue(WidgetStates.error);
      setErrorMessage("Verification code is not valid");
      notifyListeners();
      return false;
    }

    await Authentication()
        .updateCredentialsFromStorage(apiKey, _user.email, _user.username);
    await Authentication().refreshCredentialsFromStorage();
    notifyListeners();
    return true;
  }

  void setUser(User user) {
    _user = user;
  }

  void createUser() {
    CreateAccountUseCase(
      RepositoriesManager().getUserRepository(),
      User(_user.email, _user.username, _user.allergens),
    ).execute();
  }
}
