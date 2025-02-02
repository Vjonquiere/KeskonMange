import 'package:client/constants.dart' as Constants;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CreateAccountRequest{
  final String _email;
  final String _username;
  String body = "";
  CreateAccountRequest(this._email, this._username);
  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'user/create', <String, String>{"email":_email, "username":_username});
      var response = await http.post(url);
      body = response.body;
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print(e);
      }
      body = "Enable to contact server";
      return false;
    }
  }
}

class UserVerificationRequest{
  final String _email;
  final String _code;
  String body = "";
  UserVerificationRequest(this._email, this._code);
  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'user/verify', <String, String>{"email":_email, "code":_code});
      var response = await http.post(url);
      body = response.body;
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print(e);
      }
      body = "Enable to contact server";
      return false;
    }
  }
}