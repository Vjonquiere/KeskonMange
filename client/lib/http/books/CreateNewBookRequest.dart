import 'package:client/http/HttpRequest.dart';

class CreateNewBookRequest extends HttpRequest {
  final String _bookName;
  CreateNewBookRequest(this._bookName);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.post,
      'books/create',
      queryParameters: <String, String>{"name": _bookName},
      authNeeded: true,
    ));
  }
}
