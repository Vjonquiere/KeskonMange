import 'package:client/model/user.dart';
import '../../model/allergen.dart';

abstract class UserRepository {
  Future<List<Allergen>> getUserAllergens();
  Future<int> setUserAllergens(List<Allergen> allergens);
  Future<int> logout();
  Future<int> checkApiKeyValidity(String email, String token);
  Future<bool> getAuthenticationCode(String email);
  Future<bool> checkAuthenticationCode(String email, String code);
  Future<bool> createAccount(User user);
  Future<User> getUserInfos();
  Future<bool> activateUserAccount(String email, String code);
  Future<int> checkMailAvailability(String email);
  Future<int> checkUsernameAvailability(String username);
}
