import 'package:client/model/allergens.dart';
import 'package:client/model/user.dart';

abstract class UserRepository {
  Future<List<Allergens>> getUserAllergens();
  Future<int> setUserAllergens(List<Allergens> allergens);
  Future<int> logout();
  Future<int> checkApiKeyValidity(String email, String token);
  Future<int> getAuthenticationCode(String email);
  Future<int> checkAuthenticationCode(String email, String code);
  Future<int> createAccount(User user);
  Future<User> getUserInfos();
  Future<int> activateUserAccount(String email, String code);
}
