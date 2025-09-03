import 'package:client/http/http_request.dart';

import '../authentication.dart';

class LogoutRequest extends HttpRequest {
  @override
  Future<int> send() async {
    final String apiKey = Authentication().getCredentials().apiKey;
    final String email = Authentication().getCredentials().email;
    return (await super.process(
      RequestMode.post,
      'auth/logout',
      queryParameters: <String, String>{"email": email, "api_key": apiKey},
      authNeeded: true,
    ));
  }
}
