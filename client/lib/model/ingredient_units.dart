import 'package:flutter/cupertino.dart';

enum WholeItemsUnits {
  Piece,
  Clove,
  Slice,
  Stick,
  Head,
  Leaf,
  Can,
  Bottle,
  Jar,
  Package,
  Box,
  Bunch,
}

enum VolumeUnits {
  Teaspoon,
  Tablespoon,
  FluidOunce,
  Cup,
  Pint,
  Quart,
  Gallon,
  Millimiter,
  Liter
}

enum WeightUnits {
  Gram,
  Kilogram,
  Ounce,
  Pound,
}

enum SpecialUnits {
  StickOfButter,
  EggSizes,
  Sheet,
}

enum UnitCategory {
  wholeItem,
  volume,
  weight,
  special,
}

class Unit {
  final UnitCategory _unitCategory;
  final dynamic _unit;

  UnitCategory get unitCategory => _unitCategory;
  dynamic get unit => _unit;

  Unit(this._unitCategory, this._unit);

  @override
  bool operator ==(Object other) {
    if (other is! Unit) return false;
    return _unit == other._unit;
  }

  @override
  String toString() {
    return _unitCategory.toString().split(".").last;
  }

  @override
  int get hashCode => _unitCategory.hashCode ^ _unit.hashCode;
}

Unit getUnitFromString(String unitString) {
  switch (unitString) {
    case "wholeUnit":
      return Unit(UnitCategory.wholeItem, WholeItemsUnits.Bottle);
    case "volumeUnit":
      return Unit(UnitCategory.volume, VolumeUnits.Teaspoon);
    case "weightUnit":
      return Unit(UnitCategory.weight, WeightUnits.Gram);
    case "specialUnit":
      return Unit(UnitCategory.special, SpecialUnits.StickOfButter);
    default:
      throw ArgumentError('Unsupported unit string: $unitString');
  }
}
