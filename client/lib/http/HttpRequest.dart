import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:client/variables.dart' as variables;
import 'authentication.dart';

abstract class HttpRequest {
  String? _body;

  String getBody() {
    if (_body != null) return _body!;
    return "";
  }

  Map<String, dynamic> getJsonBody() {
    if (_body == null) const JsonDecoder();
    return jsonDecode(_body!);
  }

  Future<int> process(RequestMode mode, String route,
      {Map<String, String> queryParameters = const {},
      Map<String, Object> body = const {},
      bool authNeeded = false}) async {
    try {
      var url = Uri.https(variables.SERVER_URL, route, queryParameters);
      http.Response response;
      switch (mode) {
        case RequestMode.get:
          response = await http.get(url,
              headers: authNeeded ? Authentication().httpHeader() : null);
        case RequestMode.post:
          response = await http.post(url,
              headers: authNeeded ? Authentication().httpHeader() : null,
              body: body);
      }
      _body = response.body;
      if (kDebugMode)
        print("REQUEST | $route | ${response.statusCode} ${response.body}");
      return response.statusCode;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<int> send();
}

enum RequestMode { get, post }
