
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

Map<String, Unit> units = <String, Unit>{
  "whole": Unit(UnitCategory.wholeItem, WholeItemsUnits.Bottle),
  "volume": Unit(UnitCategory.volume, VolumeUnits.Gallon),
  "weight": Unit(UnitCategory.weight, WeightUnits.Gram),
  "special": Unit(UnitCategory.special, SpecialUnits.EggSizes),
};

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
  unitString = unitString.toLowerCase();
  switch (unitString) {
    case "wholeunit":
      return Unit(UnitCategory.wholeItem, WholeItemsUnits.Bottle);
    case "volumeunit":
      return Unit(UnitCategory.volume, VolumeUnits.Teaspoon);
    case "weightunit":
      return Unit(UnitCategory.weight, WeightUnits.Gram);
    case "specialunit":
      return Unit(UnitCategory.special, SpecialUnits.StickOfButter);
    default:
      throw ArgumentError('Unsupported unit string: $unitString');
  }
}
