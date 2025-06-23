import 'package:client/data/repositories/user_repository.dart';

class ActivateUserUseCase {
  final UserRepository _userRepository;
  final String _email;
  final String _code;

  ActivateUserUseCase(this._userRepository, this._email, this._code);

  Future<String?> execute() async {
    return _userRepository.activateUserAccount(_email, _code);
  }
}
