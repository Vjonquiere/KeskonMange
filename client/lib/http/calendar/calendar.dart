import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:client/constants.dart' as Constants;
import '../authentication.dart';

class NextPlannedRecipes{
  final int _count;
  NextPlannedRecipes(this._count);

  Future<int> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'calendar/next', <String, String>{"count":_count.toString()});
      var response = await http.post(url, headers: Authentication().httpHeader());
      return response.statusCode;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      return -1;
    }
  }
}