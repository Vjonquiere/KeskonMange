import 'package:client/model/user.dart';
import '../../model/allergen.dart';

abstract class UserRepository {
  Future<List<Allergen>> getUserAllergens();
  Future<int> setUserAllergens(List<Allergen> allergens);
  Future<int> logout();
  Future<int> checkApiKeyValidity(String email, String token);
  Future<int> getAuthenticationCode(String email);
  Future<int> checkAuthenticationCode(String email, String code);
  Future<int> createAccount(User user);
  Future<User> getUserInfos();
  Future<String?> activateUserAccount(String email, String code);
  Future<int> checkMailAvailability(String email);
  Future<int> checkUsernameAvailability(String username);
}
