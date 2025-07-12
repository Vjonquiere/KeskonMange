import 'package:client/model/ingredient_units.dart';

class Ingredient {
  final String name;
  final Units type;

  Ingredient(this.name, this.type);

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
      } =>
        Ingredient(name, Units.SpecialUnits),
      _ => throw const FormatException('Failed to load ingredient.'),
    };
  }
}
