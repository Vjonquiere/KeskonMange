import 'dart:convert';

import 'package:client/data/repositories/user_repository.dart';
import 'package:client/http/sign_in/check_api_key_validity_request.dart';
import 'package:client/http/sign_in/get_authentication_code_request.dart';
import 'package:client/http/sign_in/verify_authentication_code_request.dart';
import 'package:client/http/sign_up/create_account_request.dart';
import 'package:client/http/sign_up/user_verification_request.dart';
import 'package:client/http/user/get_allergens_request.dart';
import 'package:client/http/user/logout_request.dart';
import 'package:client/http/user/set_allergens_request.dart';
import 'package:client/model/user.dart';

import '../../../../http/sign_up/verify_email_request.dart';
import '../../../../http/sign_up/verify_username_request.dart';
import '../../../../model/allergen.dart';

class UserRepositoryApi extends UserRepository {
  @override
  Future<String?> activateUserAccount(String email, String code) async {
    final UserVerificationRequest req = UserVerificationRequest(email, code);
    if ((await req.send()) != 200) {
      return null;
    }
    final Map<String, dynamic> apiKey =
        jsonDecode(req.getBody()) as Map<String, dynamic>;
    if (apiKey.containsKey('token')) {
      return apiKey["token"];
    }
    return null;
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
  Future<List<Allergen>> getUserAllergens() async {
    final GetAllergensRequest req = GetAllergensRequest();
    await req.send();
    return req.getAllergens();
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
  Future<int> setUserAllergens(List<Allergen> allergens) async {
    return (await SetAllergensRequest(<String>[""])
        .send()); // TODO: Change allergens from String
  }

  @override
  Future<int> checkMailAvailability(String email) async {
    return (await VerifyEmailRequest(email).send());
  }

  @override
  Future<int> checkUsernameAvailability(String username) async {
    return (await VerifyUsernameRequest(username).send());
  }
}
