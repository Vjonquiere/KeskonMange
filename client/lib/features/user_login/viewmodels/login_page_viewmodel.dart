import 'dart:convert';

import 'package:client/core/view_model.dart';
import 'package:client/core/widget_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/repositories_manager.dart';
import '../../../data/usecases/login/check_api_key_validity_use_case.dart';
import '../../../data/usecases/login/get_authentication_code_use_case.dart';
import '../../../http/authentication.dart';
import '../../../http/sign_in/verify_authentication_code_request.dart';

class LoginPageViewModel extends ViewModel {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _signInPressed = false;
  late int _userLogged;

  bool _hasError = false;
  String _errorMessage = "";

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  int get userLogged => _userLogged;
  bool get signInPressed => _signInPressed;
  bool get hasError => _hasError;
  @override
  String get errorMessage => _errorMessage;

  LoginPageViewModel() {
    isUserLogged();
  }

  Future<void> isUserLogged() async {
    _userLogged = await CheckApiKeyValidityUseCase(
      RepositoriesManager().getUserRepository(),
    ).execute();
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  void onBackButtonPressed() {
    _signInPressed = false;
    notifyListeners();
  }

  @override
  void clearError() {
    _hasError = false;
    notifyListeners();
  }

  void onSignInPressed() async {
    _hasError = false;
    if (_emailController.text == "") {
      return;
    }
    if (signInPressed) {
      final VerifyAuthenticationCodeRequest verifyCode =
          VerifyAuthenticationCodeRequest(
        _emailController.text,
        _passwordController.text,
      );
      if (!(await verifyCode.send() == 200)) {
        _hasError = true;
        _errorMessage = verifyCode.getBody();
        notifyListeners();
        return;
      }
      final Map<String, dynamic> apiKey =
          jsonDecode(verifyCode.getBody()) as Map<String, dynamic>;
      if (apiKey.containsKey('token') && apiKey.containsKey('username')) {
        await Authentication().updateCredentialsFromStorage(
          apiKey["token"],
          _emailController.text,
          apiKey["username"],
        );
        await Authentication().refreshCredentialsFromStorage();
        _userLogged = 200;
        notifyListeners();
      }
      return;
    }
    if (!(await GetAuthenticationCodeUseCase(
          RepositoriesManager().getUserRepository(),
          _emailController.text,
        ).execute() ==
        200)) {
      _hasError = true;
      _errorMessage = "Something went wrong while trying to send code by mail";
      notifyListeners();
      return;
    }
    _signInPressed = true;
    notifyListeners();
  }
}
