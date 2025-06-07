import 'package:client/data/repositories/user_repository.dart';
import 'package:client/http/sign_in/CheckAPIKeyValidityRequest.dart';
import 'package:client/http/sign_in/GetAuthenticationCodeRequest.dart';
import 'package:client/http/sign_in/VerifyAuthenticationCodeRequest.dart';
import 'package:client/http/sign_up/CreateAccountRequest.dart';
import 'package:client/http/sign_up/UserVerificationRequest.dart';
import 'package:client/http/user/GetAllergensRequest.dart';
import 'package:client/http/user/LogoutRequest.dart';
import 'package:client/http/user/SetAllergensRequest.dart';
import 'package:client/model/allergens.dart';
import 'package:client/model/user.dart';

class UserRepositoryApi extends UserRepository {
  @override
  Future<int> activateUserAccount(String email, String code) async {
    return (await UserVerificationRequest(email, code).send());
  }

  @override
  Future<int> checkApiKeyValidity(String email, String token) async {
    return (await CheckAPIKeyValidityRequest(email, token).send());
  }

  @override
  Future<int> checkAuthenticationCode(String email, String code) async {
    return (await VerifyAuthenticationCodeRequest(email, code).send());
  }

  @override
  Future<int> createAccount(User user) async {
    return (await CreateAccountRequest(user.email, user.username).send());
  }

  @override
  Future<int> getAuthenticationCode(String email) async {
    return (await GetAuthenticationCodeRequest(email).send());
  }

  @override
  Future<List<Allergens>> getUserAllergens() async {
    GetAllergensRequest req = GetAllergensRequest();
    await req.send();
    return [req.getAllergens()];
  }

  @override
  Future<User> getUserInfos() {
    // TODO: implement getUserInfos
    throw UnimplementedError();
  }

  @override
  Future<int> logout() async {
    return (await LogoutRequest().send());
  }

  @override
  Future<int> setUserAllergens(List<Allergens> allergens) async {
    return (await SetAllergensRequest([""])
        .send()); // TODO: Change allergens from String
  }
}
