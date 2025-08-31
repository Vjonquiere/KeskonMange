import 'package:client/core/state_viewmodel.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/widget_states.dart';
import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/signup/check_mail_availability_use_case.dart';

class EmailViewModel extends StateViewModel {
  final TextEditingController _emailController = TextEditingController();

  TextEditingController get emailController => _emailController;

  @override
  Future<bool> isValid() async {
    if (_emailController.text == "") return false;
    final RegExp regex = RegExp((r'^[^\s@]+@[^\s@]+\.[^\s@]+$'));
    if (!regex.hasMatch(_emailController.text)) {
      setErrorMessage("Bad email format");
      setStateValue(WidgetStates.error);
      return false;
    }
    final CheckMailAvailabilityUseCase uniqueMail =
        CheckMailAvailabilityUseCase(
      RepositoriesManager().getUserRepository(),
      _emailController.text,
    );
    if (!(await uniqueMail.execute() == 200)) {
      setErrorMessage("Email is already used");
      setStateValue(WidgetStates.error);
      return false;
    }
    return true;
  }
}
