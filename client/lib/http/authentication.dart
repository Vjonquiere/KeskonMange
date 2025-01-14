import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentication{
  static final Authentication _singleton = Authentication._internal();
  final _storage = const FlutterSecureStorage();
  final Credentials _credentials = Credentials();

  factory Authentication() {
    return _singleton;
  }

  Authentication._internal();

  Future<bool> initCredentialsFromStorage() async {
    try {
      _credentials.api_key = (await _storage.read(key: "x-api-key"))!;
      _credentials.email = (await _storage.read(key: "email"))!;
    } catch(e) {
      return false;
    }
    return true;
  }

  Credentials getCredentials(){
    return _credentials;
  }

}

class Credentials{
  late String api_key;
  late String email;

  Credentials();

}