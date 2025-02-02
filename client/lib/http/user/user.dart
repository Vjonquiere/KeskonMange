import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import '../authentication.dart';
import 'package:http/http.dart' as http;
import 'package:client/constants.dart' as Constants;

class SetAllergens{
  final List<String> _allergens;
  SetAllergens(this._allergens);

  Future<int> request() async {
    for (final allergen in _allergens){
      if (!Constants.allergens.contains(allergen)){
        return -1; // One allergens is not valid
      }
    }
    try {
      var url = Uri.http(Constants.SERVER_URL, 'user/allergens', <String, String>{"email":Authentication().getCredentials().email});
      var response = await http.post(url, headers: Authentication().httpHeader(),
        body:
          {
            "allergens": _allergens,
          }
      );
      return response.statusCode;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      return -1;
    }
  }
}

class GetAllergens{
  Allergens? _allergens;

  GetAllergens();

  Future<int> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'user/allergens', <String, String>{"email":Authentication().getCredentials().email});
      var response = await http.post(url, headers: Authentication().httpHeader());
      _allergens = Allergens.fromJson(jsonDecode(response.body));
      return response.statusCode;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      return -1;
    }
  }

  Allergens? getAllergens(){
    return _allergens;
  }
}

class Allergens{
  List<String> allergens;

  Allergens(this.allergens);

  factory Allergens.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'allergens': List<String> allergens,
      } =>
          Allergens(allergens),
      _ => throw const FormatException('Failed to load allergens.'),
    };
  }
}