import 'package:client/core/message.dart';
import 'package:client/core/message_bus.dart';
import 'package:client/data/repositories/user_repository.dart';
import 'package:client/model/allergen.dart';
import 'package:client/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as S;

class UserRepositorySupabase extends UserRepository{
  @override
  Future<bool> activateUserAccount(String email, String code) async {
    try{
      final S.AuthResponse res = await S.Supabase.instance.client.auth.verifyOTP(email: email, type: S.OtpType.signup, token: code);
      return res.session != null;
    } catch (e){
      MessageBus.instance.addMessage(Message(MessageType.error, e.toString()));
      return false;
    }
  }

  @override
  Future<int> checkApiKeyValidity(String email, String token) async {
    return S.Supabase.instance.client.auth.currentSession != null ? 200 : 404;
  }

  @override
  Future<bool> checkAuthenticationCode(String email, String code) async {
    try{
      await S.Supabase.instance.client.auth.verifyOTP(email: email, type: S.OtpType.email, token: code);
    } catch (e){
      MessageBus.instance.addMessage(Message(MessageType.error, e.toString()));
      return false;
    }
    return true;
  }

  @override
  Future<int> checkMailAvailability(String email) async {
   return 200;
  }

  @override
  Future<int> checkUsernameAvailability(String username) async {
    return 200;
  }

  @override
  Future<bool> createAccount(User user) async {
    try{
      await S.Supabase.instance.client.auth.signInWithOtp(email: user.email);
    } catch (e){
      MessageBus.instance.addMessage(Message(MessageType.error, e.toString()));
      return false;
    }
    return true;

  }

  @override
  Future<bool> getAuthenticationCode(String email) {
    return createAccount(User(email, "", []));
  }

  @override
  Future<List<Allergen>> getUserAllergens() {
    // TODO: implement getUserAllergens
    throw UnimplementedError();
  }

  @override
  Future<User> getUserInfos() {
    // TODO: implement getUserInfos
    throw UnimplementedError();
  }

  @override
  Future<int> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<int> setUserAllergens(List<Allergen> allergens) {
    // TODO: implement setUserAllergens
    throw UnimplementedError();
  }

}