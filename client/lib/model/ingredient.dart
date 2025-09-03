import 'package:client/model/ingredient_units.dart';

class Ingredient {
  final String _name;
  final List<Unit> _type;
  int _id = -1;

  Ingredient(this._name, this._type);
  Ingredient._(this._name, this._type, this._id);
  Ingredient.withId(this._id, this._name, this._type);

  String get name => _name;
  List<Unit> get type => _type;
  int get id => _id;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'name': final String name,
        'units': final List<dynamic> units,
      } =>
        Ingredient._(
          name,
          units.map((dynamic e) => getUnitFromString(e as String)).toList(),
          id,
        ),
      {
        'id': final int id,
        'name': final String name,
      } =>
        Ingredient._(
          name,
          <Unit>[Unit(UnitCategory.special, SpecialUnits.eggSizes)],
          id,
        ),
      {
        'name': final String name,
      } =>
        Ingredient(
            name, <Unit>[Unit(UnitCategory.special, SpecialUnits.eggSizes)]),
      _ => throw const FormatException('Failed to load ingredient.'),
    };
  }
}
