import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:client/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:client/http/authentication.dart';


class CreateRecipe{
  final Recipe _recipe;
  final RecipeRestrictions _recipeRestrictions;
  final RecipeTime _recipeTime;

  CreateRecipe(this._recipe, this._recipeRestrictions, this._recipeTime);

  Future<int> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'recipe/add');
      var response = await http.post(url, headers: Authentication().httpHeader(),
          body: {
            'title': _recipe.title,
            'type': _recipe.type,
            'difficulty': _recipe.difficulty,
            'cost': _recipe.cost,
            'portions': _recipe.portions,
            'salty': _recipeRestrictions.salty,
            'sweet': _recipeRestrictions.sweet,
            'preparation_time': _recipeTime.preparation,
            'rest_time': _recipeTime.rest,
            'cook_time': _recipeTime.cook,
            'ingredients': [], //TODO: Add ingredients to body
      });
      return response.statusCode;
    } on Exception catch (e){
      if (kDebugMode) {
        print (e);
      }
      return -1;
    }
  }

}

class GetRecipe {
  final String _id;
  Map<String, dynamic>? body;
  GetRecipe(this._id);

  Future<bool> request() async {
    try {
      var url = Uri.http(Constants.SERVER_URL, 'recipe/$_id');
      var response = await http.get(url, headers: Authentication().httpHeader());
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
    if (body != null) return Recipe.fromJson(body!);
    return null;
  }

}

class RecipeRestrictions{
  final int vegetarian;
  final int vegan;
  final int hasGluten;
  final int hasLactose;
  final int hasPork;
  final int salty;
  final int sweet;

  RecipeRestrictions(this.vegetarian, this.vegan, this.hasGluten, this.hasLactose, this.hasPork, this.salty, this.sweet);
}

class RecipeTime{
  final int preparation;
  final int rest;
  final int cook;
  RecipeTime(this.preparation, this.rest, this.cook);
}

class Recipe {
  final int id;
  final String title;
  final String type;
  final int difficulty;
  final int cost;
  final int portions;
  final int owner;
  final int visibility;
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
      'vegetarian': int vegetarian,
      'vegan': int vegan,
      'hasGluten': int hasGluten,
      'hasLactose': int hasLactose,
      'hasPork': int hasPork,
      'salty': int salty,
      'sweet': int sweet,
      'owner': int owner,
      'visibility': int visibility,
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
      'visibility': int visibility,
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