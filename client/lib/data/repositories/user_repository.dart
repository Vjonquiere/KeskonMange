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
  Future<int> activateUserAccount(String email, String code);
}
