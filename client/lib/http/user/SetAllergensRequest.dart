import 'package:client/http/HttpRequest.dart';
import 'package:client/constants.dart' as constants;
import '../authentication.dart';

class SetAllergensRequest extends HttpRequest {
  final List<String> _allergens;
  SetAllergensRequest(this._allergens);

  @override
  Future<int> send() async {
    for (final String allergen in _allergens) {
      if (!constants.allergens.contains(allergen)) {
        return -1; // One allergens is not valid
      }
    }
    return (await super.process(RequestMode.post, 'user/allergens',
        queryParameters: <String, String>{
          "email": Authentication().getCredentials().email,
        },
        body: <String, Object>{"allergens": _allergens},
        authNeeded: true,));
  }
}
