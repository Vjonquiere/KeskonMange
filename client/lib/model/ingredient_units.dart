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

  factory Unit.fromString(String unit) {
    return switch (unit) {
      "pc" => Unit(UnitCategory.wholeItem, WholeItemsUnits.piece),
      "clv" => Unit(UnitCategory.wholeItem, WholeItemsUnits.clove),
      "slc" => Unit(UnitCategory.wholeItem, WholeItemsUnits.slice),
      "stk" => Unit(UnitCategory.wholeItem, WholeItemsUnits.stick),
      "hd" => Unit(UnitCategory.wholeItem, WholeItemsUnits.head),
      "lf" => Unit(UnitCategory.wholeItem, WholeItemsUnits.leaf),
      "cn" => Unit(UnitCategory.wholeItem, WholeItemsUnits.can),
      "btl" => Unit(UnitCategory.wholeItem, WholeItemsUnits.bottle),
      "jr" => Unit(UnitCategory.wholeItem, WholeItemsUnits.jar),
      "pkg" => Unit(UnitCategory.wholeItem, WholeItemsUnits.package),
      "bx" => Unit(UnitCategory.wholeItem, WholeItemsUnits.box),
      "bnch" => Unit(UnitCategory.wholeItem, WholeItemsUnits.bunch),
      "tsp" => Unit(UnitCategory.volume, VolumeUnits.teaspoon),
      "tbsp" => Unit(UnitCategory.volume, VolumeUnits.tablespoon),
      "floz" => Unit(UnitCategory.volume, VolumeUnits.fluidOunce),
      "c" => Unit(UnitCategory.volume, VolumeUnits.cup),
      "pt" => Unit(UnitCategory.volume, VolumeUnits.pint),
      "qt" => Unit(UnitCategory.volume, VolumeUnits.quart),
      "gal" => Unit(UnitCategory.volume, VolumeUnits.gallon),
      "ml" => Unit(UnitCategory.volume, VolumeUnits.milliliter),
      "l" => Unit(UnitCategory.volume, VolumeUnits.liter),
      "g" => Unit(UnitCategory.weight, WeightUnits.gram),
      "kg" => Unit(UnitCategory.weight, WeightUnits.kilogram),
      "oz" => Unit(UnitCategory.weight, WeightUnits.ounce),
      "lbs" => Unit(UnitCategory.weight, WeightUnits.pound),
      "sb" => Unit(UnitCategory.special, SpecialUnits.stickOfButter),
      "egg" => Unit(UnitCategory.special, SpecialUnits.eggSizes),
      "sht" => Unit(UnitCategory.special, SpecialUnits.sheet),
      _ => throw FormatException("Can't assign string: $unit to a known unit"),
    };
  }
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
      return Unit(UnitCategory.wholeItem, WholeItemsUnits.piece);
      throw ArgumentError('Unsupported unit string: $unitString');
  }
}
