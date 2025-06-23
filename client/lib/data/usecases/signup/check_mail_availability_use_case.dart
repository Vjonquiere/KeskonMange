import 'package:client/data/repositories/user_repository.dart';

class CheckMailAvailabilityUseCase {
  final UserRepository _userRepository;
  final String _email;

  CheckMailAvailabilityUseCase(this._userRepository, this._email);

  Future<int> execute() async {
    return _userRepository.checkMailAvailability(_email);
  }
}
