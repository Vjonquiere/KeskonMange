import 'package:client/data/repositories/user_repository.dart';

class GetAuthenticationCodeUseCase {
  final UserRepository _userRepository;
  final String _email;

  GetAuthenticationCodeUseCase(this._userRepository, this._email);

  Future<bool> execute() async {
    return _userRepository.getAuthenticationCode(_email);
  }
}
