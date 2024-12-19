import 'package:http/http.dart' as http;
import 'package:client/constants.dart' as Constants;

class VerifyUsernameRequest {
  final String _username;
  VerifyUsernameRequest(this._username);

  Future<bool> request() async {
    var url = Uri.http(Constants.SERVER_URL, 'user/availableUsername?username=$_username');
    var response = await http.get(url);
    return response.statusCode == 200;
  }
}

class VerifyEmailRequest {
  final String _email;
  VerifyEmailRequest(this._email);
  Future<bool> request() async {
    var url = Uri.http(Constants.SERVER_URL, 'user/availableEmail?email=$_email');
    var response = await http.get(url);
    return response.statusCode == 200;
  }
}