import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentication {
  static final Authentication _singleton = Authentication._internal();
  final _storage = const FlutterSecureStorage();
  final Credentials _credentials = Credentials();

  factory Authentication() {
    return _singleton;
  }

  Authentication._internal();

  Future<bool> initCredentialsFromStorage() async {
    try {
      _credentials.apiKey = (await _storage.read(key: "x-api-key"))!;
      _credentials.email = (await _storage.read(key: "email"))!;
      _credentials.username = (await _storage.read(key: "username"))!;
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> refreshCredentialsFromStorage() async {
    _credentials.apiKey = "";
    _credentials.email = "";
    _credentials.username = "";
    return await initCredentialsFromStorage();
  }

  Future<void> deleteCredentialsFromStorage() async {
    await _storage.delete(key: 'x-api-key');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'username');
  }

  Future<void> updateCredentialsFromStorage(
      String apiKey, String email, String username) async {
    await _storage.write(key: "x-api-key", value: apiKey);
    await _storage.write(key: "email", value: email);
    await _storage.write(key: "username", value: username);
  }

  Map<String, String> httpHeader() {
    // TODO: add real username
    return {
      "x-api-key": _credentials.apiKey,
      "username": _credentials.username,
      "email": _credentials.email
    };
  }

  Credentials getCredentials() {
    return _credentials;
  }
}

class Credentials {
  late String apiKey;
  late String email;
  late String username;

  Credentials();
}
