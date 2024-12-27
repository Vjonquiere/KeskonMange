import 'package:client/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GetAuthenticationCode {
  final String _email;
  String body = "";
  GetAuthenticationCode(this._email);

  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'auth/signin', <String, String>{"email":_email});
      var response = await http.post(url);
      body = response.body;
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      body = "Unable to contact server";
      return false;
    }
  }

}

class VerifyAuthenticationCode {
  final String _email;
  final String _code;
  String body = "";
  VerifyAuthenticationCode(this._email, this._code);

  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'auth/signin', <String, String>{"email":_email, "code":_code});
      var response = await http.post(url);
      body = response.body;
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      body = "Unable to contact server";
      return false;
    }
  }

}

class CheckAPIKeyValidity {
  final String _email;
  final String _token;
  String body = "";
  CheckAPIKeyValidity(this._email, this._token);

  Future<int> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'auth/test', <String, String>{"email":_email, "api_key":_token});
      var response = await http.post(url);
      body = response.body;
      return response.statusCode;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      body = "Unable to contact server";
      return -1;
    }
  }
}