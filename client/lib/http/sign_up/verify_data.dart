import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:client/constants.dart' as Constants;

class VerifyUsernameRequest {
  final String _username;
  VerifyUsernameRequest(this._username);

  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'user/availableUsername', <String, String>{"username":_username});
      var response = await http.get(url);
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      return false;
    }


  }
}

class VerifyEmailRequest {
  final String _email;
  VerifyEmailRequest(this._email);
  
  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'user/availableEmail', <String, String>{"email":_email});
      var response = await http.get(url);
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print(e);
      }
      return false;
    }

  }
}