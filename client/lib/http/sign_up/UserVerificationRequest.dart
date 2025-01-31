import 'package:client/http/HttpRequest.dart';

class UserVerificationRequest extends HttpRequest{
  final String _email;
  final String _code;
  UserVerificationRequest(this._email, this._code);

  @override
  Future<int> send() async {
    return (await super.process(RequestMode.post, 'user/verify', queryParameters: <String, String>{"email":_email, "code":_code}));
  }
}