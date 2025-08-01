import 'dart:convert';
import 'package:client/http/HttpRequest.dart';
import 'package:client/model/allergen.dart';
import '../authentication.dart';

class GetAllergensRequest extends HttpRequest {
  GetAllergensRequest();

  List<Allergen> getAllergens() {
    List<Allergen> reqAllergens = [];
    switch (getJsonBody()) {
      case {
          'allergens': List<String> allergens,
        }:
        for (String allergen in allergens) {
          reqAllergens.add(Allergen.fromString(allergen));
        }
    }
    return reqAllergens;
  }

  @override
  Future<int> send() async {
    return (await super.process(RequestMode.get, 'user/allergens',
        queryParameters: <String, String>{
          "email": Authentication().getCredentials().email
        },
        authNeeded: true));
  }
}
