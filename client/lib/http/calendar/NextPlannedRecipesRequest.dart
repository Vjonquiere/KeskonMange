import 'package:client/http/HttpRequest.dart';

class NextPlannedRecipesRequest extends HttpRequest {
  final int _count;
  NextPlannedRecipesRequest(this._count);

  @override
  Future<int> send() async {
    return (await super.process(RequestMode.post, 'calendar/next',
        queryParameters: <String, String>{"count": _count.toString()},
        authNeeded: true,));
  }
}
