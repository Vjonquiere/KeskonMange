import 'package:client/http/http_request.dart';

class VerifyUsernameRequest extends HttpRequest {
  final String _username;
  VerifyUsernameRequest(this._username);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.get,
      'user/availableUsername',
      queryParameters: <String, String>{"username": _username},
    ));
  }
}
