import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:client/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:client/http/authentication.dart';

class GetRecipe {
  final String _id;
  Map<String, dynamic>? body;
  GetRecipe(this._id);

  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'recipe/$_id');
      var response = await http.post(url, headers: Authentication().httpHeader());
      body = jsonDecode(response.body);
      return response.statusCode == 200;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      return false;
    }
  }
  
  Recipe? getRecipe(){
    if (body != null) Recipe.fromJson(body!);
    return null;
  }

}

class RecipeRestrictions{
  final bool vegetarian;
  final bool vegan;
  final bool hasGluten;
  final bool hasLactose;
  final bool hasPork;
  final bool salty;
  final bool sweet;

  RecipeRestrictions(this.vegetarian, this.vegan, this.hasGluten, this.hasLactose, this.hasPork, this.salty, this.sweet);
}

class Recipe {
  final int id;
  final String title;
  final String type;
  final int difficulty;
  final int cost;
  final int portions;
  final int owner;
  final bool visibility;
  RecipeRestrictions? restrictions;

  Recipe(this.id, this.title, this.type, this.difficulty, this.cost, this.portions, this.owner, this.visibility, {this.restrictions});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      { // Build with restrictions
      'id': int id,
      'title': String title,
      'type': String type,
      'difficulty': int difficulty,
      'cost': int cost,
      'portions': int portions,
      'owner': int owner,
      'visibility': bool visibility,
      'vegetarian': bool vegetarian,
      'vegan': bool vegan,
      'hasGluten': bool hasGluten,
      'hasLactose': bool hasLactose,
      'hasPork': bool hasPork,
      'salty': bool salty,
      'sweet': bool sweet,
      } =>
          Recipe(
              id,
              title,
              type,
              difficulty,
              cost,
              portions,
              owner,
              visibility,
              restrictions: RecipeRestrictions(vegetarian, vegan, hasGluten, hasLactose, hasPork, salty, sweet)
          ),
      { // Build without restrictions
      'id': int id,
      'title': String title,
      'type': String type,
      'difficulty': int difficulty,
      'cost': int cost,
      'portions': int portions,
      'owner': int owner,
      'visibility': bool visibility,
      } =>
          Recipe(
            id,
            title,
            type,
            difficulty,
            cost,
            portions,
            owner,
            visibility,
          ),
      _ => throw const FormatException('Failed to load recipe.'),
    };
  }
}