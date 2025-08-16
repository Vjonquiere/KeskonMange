import 'package:client/core/ViewModel.dart';
import 'package:client/features/user_signup/viewmodels/email_viewmodel.dart';
import 'package:client/features/user_signup/viewmodels/post_code_viewmodel.dart';
import 'package:client/features/user_signup/viewmodels/username_viewmodel.dart';
import 'package:client/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/state_viewmodel.dart';
import '../../../core/widget_states.dart';
import 'account_verification_viewmodel.dart';
import 'allergens_viewmodel.dart';

class SignupViewModel extends ViewModel {
  final storage = const FlutterSecureStorage();
  final UsernameViewModel _usernameViewModel = UsernameViewModel();
  final EmailViewModel _emailViewModel = EmailViewModel();
  final PostCodeViewModel _postCodeViewModel = PostCodeViewModel();
  final AllergensViewModel _allergensViewModel = AllergensViewModel();
  final AccountVerificationViewModel _accountVerificationViewModel =
      AccountVerificationViewModel();

  double _progressBarValue = 0.0;
  int _currentIndex = 0;
  bool _signupFinalized = false;
  late final List<StateViewModel> _viewModels = [
    _usernameViewModel,
    _emailViewModel,
    _postCodeViewModel,
    _allergensViewModel,
    _accountVerificationViewModel,
  ];

  int get currentIndex => _currentIndex;
  double get progressBarValue => _progressBarValue;
  bool get signupFinalized => _signupFinalized;
  StateViewModel get currentViewModel => _viewModels[_currentIndex];
  int get _stepCount => _viewModels.length;
  bool get isStepStateError => currentViewModel.state == WidgetStates.error;
  String? get currentStepErrorMessage => currentViewModel.errorMessage;

  Future<void> nextStep() async {
    if (await (currentViewModel.isValid())) {
      if (_currentIndex == _stepCount-1) _signupFinalized = true;
      _currentIndex += 1;
      _progressBarValue = _currentIndex / _stepCount;
      if (_currentIndex == _stepCount - 1) {
        _accountVerificationViewModel.setUser(User(
            _emailViewModel.emailController.text,
            _usernameViewModel.usernameController.text,
            [])); // TODO: Translate bool list to allergens
        _accountVerificationViewModel.createUser();
      }
    }
    notifyListeners();
  }

  Future<void> previousStep() async {
    _currentIndex += 1;
    _progressBarValue = _currentIndex / _stepCount;
    notifyListeners();
  }
}
