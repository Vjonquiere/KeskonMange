import 'package:client/http/http_request.dart';

class CheckAPIKeyValidityRequest extends HttpRequest {
  final String _email;
  final String _token;
  CheckAPIKeyValidityRequest(this._email, this._token);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.post,
      'auth/test',
      queryParameters: <String, String>{"email": _email, "api_key": _token},
    ));
  }
}
