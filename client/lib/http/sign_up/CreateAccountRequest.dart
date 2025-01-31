import 'package:client/http/HttpRequest.dart';

class CreateAccountRequest extends HttpRequest{
  final String _email;
  final String _username;
  CreateAccountRequest(this._email, this._username);

  @override
  Future<int> send() async {
    return (await super.process(
        RequestMode.post,
        'user/create',
        queryParameters: <String, String>{"email":_email, "username":_username}
    ));
  }
}