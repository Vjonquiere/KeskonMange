import 'package:client/data/repositories/user_repository.dart';

import '../../../http/authentication.dart';
import '../../../http/sign_in/CheckAPIKeyValidityRequest.dart';

class CheckApiKeyValidityUseCase {
  final UserRepository _userRepository;

  CheckApiKeyValidityUseCase(this._userRepository);

  Future<int> execute() async {
    if (!(await Authentication().initCredentialsFromStorage())) {
      await Authentication()
          .deleteCredentialsFromStorage(); // Credentials are missing, don't try to check their validity
      return -1;
    }
    String API_KEY = Authentication().getCredentials().apiKey;
    String email = Authentication().getCredentials().email;
    return _userRepository.checkApiKeyValidity(email, API_KEY);
  }
}
