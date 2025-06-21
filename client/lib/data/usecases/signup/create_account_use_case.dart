import 'package:client/data/repositories/user_repository.dart';

import '../../../model/user.dart';

class CreateAccountUseCase {
  final UserRepository _userRepository;
  final User _user;

  CreateAccountUseCase(this._userRepository, this._user);

  Future<int> execute() async {
    return _userRepository.createAccount(_user);
  }
}
