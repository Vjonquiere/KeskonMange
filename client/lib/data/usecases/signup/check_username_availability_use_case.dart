import 'package:client/data/repositories/user_repository.dart';

class CheckUsernameAvailabilityUseCase {
  final UserRepository _userRepository;
  final String _username;

  CheckUsernameAvailabilityUseCase(this._userRepository, this._username);

  Future<int> execute() async {
    return _userRepository.checkUsernameAvailability(_username);
  }
}
