import 'package:client/http/http_request.dart';

class CompleteMonthRequest extends HttpRequest {
  final int _previous;

  CompleteMonthRequest(this._previous);

  @override
  Future<int> send() async {
    return (await super.process(
      RequestMode.get,
      "calendar/completeMonth",
      queryParameters: <String, String>{"previous": _previous.toString()},
      authNeeded: true,
    ));
  }
}
