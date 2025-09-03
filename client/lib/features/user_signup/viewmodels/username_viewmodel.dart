import 'package:flutter/cupertino.dart';

import '../../../core/state_viewmodel.dart';
import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/signup/check_username_availability_use_case.dart';

class UsernameViewModel extends StateViewModel {
  final TextEditingController _usernameController = TextEditingController();

  TextEditingController get usernameController => _usernameController;

  @override
  Future<bool> isValid() async {
    if (_usernameController.text == "") {
      return false;
    }
    final CheckUsernameAvailabilityUseCase uniqueUsername =
        CheckUsernameAvailabilityUseCase(
      RepositoriesManager().getUserRepository(),
      _usernameController.text,
    );
    if (!(await uniqueUsername.execute() == 200)) {
      setStateValue(WidgetStates.error);
      setErrorMessage("Username is already taken");
      return false;
    }
    return true;
  }
}
