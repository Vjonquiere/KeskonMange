import 'package:client/http/http_request.dart';

class GetAuthenticationCodeRequest extends HttpRequest {
  final String _email;
  GetAuthenticationCodeRequest(this._email);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.post,
      'auth/signin',
      queryParameters: <String, String>{"email": _email},
    ));
  }
}
