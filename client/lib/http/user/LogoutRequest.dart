import 'package:client/http/HttpRequest.dart';

import '../authentication.dart';

class LogoutRequest extends HttpRequest {
  @override
  Future<int> send() async {
    var apiKey = Authentication().getCredentials().apiKey;
    var email = Authentication().getCredentials().email;
    return (await super.process(RequestMode.post, 'auth/logout',
        queryParameters: <String, String>{"email": email, "api_key": apiKey},
        authNeeded: true));
  }
}
