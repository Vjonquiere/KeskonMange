import 'dart:convert';
import 'package:client/http/HttpRequest.dart';
import '../../model/allergens.dart';
import '../authentication.dart';

class GetAllergensRequest extends HttpRequest{
  GetAllergensRequest();

  Allergens? getAllergens(){
    return Allergens.fromJson(jsonDecode(getBody()));
  }

  @override
  Future<int> send() async {
    return (await super.process(
        RequestMode.get,
        'user/allergens',
        queryParameters: <String, String>{"email":Authentication().getCredentials().email}
    ));
  }
}
