import 'package:client/data/repositories/user_repository.dart';
import 'package:client/model/user.dart';

import '../../../../model/allergen.dart';

class UserRepositoryMock extends UserRepository {
  User? _current;

  @override
  Future<String?> activateUserAccount(String email, String code) async {
    return "API_KEY";
  }

  @override
  Future<int> checkApiKeyValidity(String email, String token) async {
    return 200;
  }

  @override
  Future<int> checkAuthenticationCode(String email, String code) async {
    return 200;
  }

  @override
  Future<int> createAccount(User user) async {
    _current = user;
    return 200;
  }

  @override
  Future<int> getAuthenticationCode(String email) async {
    return 200;
  }

  @override
  Future<List<Allergen>> getUserAllergens() async {
    if (_current == null) {
      return <Allergen>[];
    }
    return _current!.allergens;
  }

  @override
  Future<User> getUserInfos() async {
    return _current!;
  }

  @override
  Future<int> logout() async {
    return 200;
  }

  @override
  Future<int> setUserAllergens(List<Allergen> allergens) async {
    _current!.allergens = allergens;
    return 200;
  }

  @override
  Future<int> checkMailAvailability(String email) async {
    if (_current?.email == email) {
      return 400;
    }
    return 200;
  }

  @override
  Future<int> checkUsernameAvailability(String username) async {
    if (_current?.username == username) {
      return 400;
    }
    return 200;
  }
}
