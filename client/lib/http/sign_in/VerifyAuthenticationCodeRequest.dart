import 'package:client/http/HttpRequest.dart';

class VerifyAuthenticationCodeRequest extends HttpRequest {
  final String _email;
  final String _code;
  VerifyAuthenticationCodeRequest(this._email, this._code);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.post,
      'auth/signin',
      queryParameters: <String, String>{"email": _email, "code": _code},
    ));
  }
}
