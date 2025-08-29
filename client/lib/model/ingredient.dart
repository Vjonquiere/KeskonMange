import 'package:client/model/ingredient_units.dart';

class Ingredient {
  final String _name;
  final List<Unit> _type;
  int _id = -1;

  Ingredient(this._name, this._type);
  Ingredient._(this._name, this._type, this._id);

  String get name => _name;
  List<Unit> get type => _type;
  int get id => _id;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'units': List<dynamic> units,
      } =>
        Ingredient._(name,
            units.map((e) => getUnitFromString(e as String)).toList(), id),
      {
        'id': int id,
        'name': String name,
      } =>
        Ingredient._(
            name, [Unit(UnitCategory.special, SpecialUnits.EggSizes)], id),
      {
        'name': String name,
      } =>
        Ingredient(name, [Unit(UnitCategory.special, SpecialUnits.EggSizes)]),
      _ => throw const FormatException('Failed to load ingredient.'),
    };
  }
}
