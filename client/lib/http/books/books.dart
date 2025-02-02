import 'package:flutter/foundation.dart';
import 'package:client/constants.dart' as Constants;
import 'package:http/http.dart' as http;

import '../authentication.dart';

class CreateNewBook{
  final String _bookName;
  CreateNewBook(this._bookName);

  Future<int> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'books/create', <String, String>{"name":_bookName});
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

class AddRecipeToBook{
  final int _recipeId;
  final int _bookId;
  AddRecipeToBook(this._recipeId, this._bookId);

  Future<int> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'books/recipe/add', <String, String>{"bookId":_bookId.toString(), "recipeId":_recipeId.toString()});
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