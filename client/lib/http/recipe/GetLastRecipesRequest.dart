
import 'package:client/http/HttpRequest.dart';

class GetLastRecipesRequest extends HttpRequest {
  List<int> ids() {
    return super.getJsonBody().containsKey("id")
        ? super.getJsonBody()["id"]
        : [];
  }

  @override
  Future<int> send() {
    return super.process(RequestMode.get, "/recipe/last");
  }
}
