enum WholeItemsUnits {
  piece,
  clove,
  slice,
  stick,
  head,
  leaf,
  can,
  bottle,
  jar,
  package,
  box,
  bunch,
}

enum VolumeUnits {
  teaspoon,
  tablespoon,
  fluidOunce,
  cup,
  pint,
  quart,
  gallon,
  milliliter,
  liter
}

enum WeightUnits {
  gram,
  kilogram,
  ounce,
  pound,
}

enum SpecialUnits {
  stickOfButter,
  eggSizes,
  sheet,
}

enum UnitCategory {
  wholeItem,
  volume,
  weight,
  special,
}

Map<String, Unit> units = <String, Unit>{
  "whole": Unit(UnitCategory.wholeItem, WholeItemsUnits.bottle),
  "volume": Unit(UnitCategory.volume, VolumeUnits.gallon),
  "weight": Unit(UnitCategory.weight, WeightUnits.gram),
  "special": Unit(UnitCategory.special, SpecialUnits.eggSizes),
};

class Unit {
  final UnitCategory _unitCategory;
  final dynamic _unit;

  UnitCategory get unitCategory => _unitCategory;
  dynamic get unit => _unit;

  Unit(this._unitCategory, this._unit);

  @override
  bool operator ==(Object other) {
    if (other is! Unit) {
      return false;
    }
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
      return Unit(UnitCategory.wholeItem, WholeItemsUnits.bottle);
    case "volumeunit":
      return Unit(UnitCategory.volume, VolumeUnits.teaspoon);
    case "weightunit":
      return Unit(UnitCategory.weight, WeightUnits.gram);
    case "specialunit":
      return Unit(UnitCategory.special, SpecialUnits.stickOfButter);
    default:
      throw ArgumentError('Unsupported unit string: $unitString');
  }
}
