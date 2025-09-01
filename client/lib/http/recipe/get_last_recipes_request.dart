import 'package:client/http/http_request.dart';

class GetLastRecipesRequest extends HttpRequest {
  List<int> ids() {
    return super.getJsonBody().containsKey("id")
        ? super.getJsonBody()["id"]
        : <int>[];
  }

  @override
  Future<int> send() {
    return super.process(RequestMode.get, "/recipe/last");
  }
}
