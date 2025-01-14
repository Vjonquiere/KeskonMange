import 'package:flutter/foundation.dart';
import 'package:client/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:client/http/authentication.dart';

class GetRecipe {
  final String _id;
  String body = "";
  GetRecipe(this._id);

  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'recipe/$_id');
      var credentials = Authentication().getCredentials();
      var response = await http.post(url, headers: <String, String>{"x-api-key": credentials.api_key, "username": ""}); // TODO: add username to credentials
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