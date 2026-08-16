import 'package:client/data/repositories/user_repository.dart';
import 'package:client/model/user.dart';

import '../../../../model/allergen.dart';

class UserRepositoryMock extends UserRepository {
  User? _current;

  @override
  Future<bool> activateUserAccount(String email, String code) async {
    return true;
  }

  @override
  Future<int> checkApiKeyValidity(String email, String token) async {
    return 200;
  }

  @override
  Future<bool> checkAuthenticationCode(String email, String code) async {
    return true;
  }

  @override
  Future<bool> createAccount(User user) async {
    _current = user;
    return true;
  }

  @override
  Future<bool> getAuthenticationCode(String email) async {
    return true;
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
