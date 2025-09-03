import 'package:client/http/http_request.dart';

class GetUserInfos extends HttpRequest {
  @override
  Future<int> send() async {
    return (await super
        .process(RequestMode.get, "user/infos", authNeeded: true));
  }
}
