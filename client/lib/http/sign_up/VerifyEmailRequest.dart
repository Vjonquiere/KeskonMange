import 'package:client/http/HttpRequest.dart';

class VerifyEmailRequest extends HttpRequest{
  final String _email;
  VerifyEmailRequest(this._email);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.get,
      'user/availableEmail',
      queryParameters: <String, String>{"email":_email}
    ));
  }
}