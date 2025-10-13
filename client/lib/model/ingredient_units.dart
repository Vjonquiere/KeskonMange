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
  wholeunit,
  volumeunit,
  weightunit,
  specialunit,
}

Map<String, Unit> units = <String, Unit>{
  "whole": Unit(UnitCategory.wholeunit, WholeItemsUnits.bottle),
  "volume": Unit(UnitCategory.volumeunit, VolumeUnits.gallon),
  "weight": Unit(UnitCategory.weightunit, WeightUnits.gram),
  "special": Unit(UnitCategory.specialunit, SpecialUnits.eggSizes),
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
      "pc" => Unit(UnitCategory.wholeunit, WholeItemsUnits.piece),
      "clv" => Unit(UnitCategory.wholeunit, WholeItemsUnits.clove),
      "slc" => Unit(UnitCategory.wholeunit, WholeItemsUnits.slice),
      "stk" => Unit(UnitCategory.wholeunit, WholeItemsUnits.stick),
      "hd" => Unit(UnitCategory.wholeunit, WholeItemsUnits.head),
      "lf" => Unit(UnitCategory.wholeunit, WholeItemsUnits.leaf),
      "cn" => Unit(UnitCategory.wholeunit, WholeItemsUnits.can),
      "btl" => Unit(UnitCategory.wholeunit, WholeItemsUnits.bottle),
      "jr" => Unit(UnitCategory.wholeunit, WholeItemsUnits.jar),
      "pkg" => Unit(UnitCategory.wholeunit, WholeItemsUnits.package),
      "bx" => Unit(UnitCategory.wholeunit, WholeItemsUnits.box),
      "bnch" => Unit(UnitCategory.wholeunit, WholeItemsUnits.bunch),
      "tsp" => Unit(UnitCategory.volumeunit, VolumeUnits.teaspoon),
      "tbsp" => Unit(UnitCategory.volumeunit, VolumeUnits.tablespoon),
      "floz" => Unit(UnitCategory.volumeunit, VolumeUnits.fluidOunce),
      "c" => Unit(UnitCategory.volumeunit, VolumeUnits.cup),
      "pt" => Unit(UnitCategory.volumeunit, VolumeUnits.pint),
      "qt" => Unit(UnitCategory.volumeunit, VolumeUnits.quart),
      "gal" => Unit(UnitCategory.volumeunit, VolumeUnits.gallon),
      "ml" => Unit(UnitCategory.volumeunit, VolumeUnits.milliliter),
      "l" => Unit(UnitCategory.volumeunit, VolumeUnits.liter),
      "g" => Unit(UnitCategory.weightunit, WeightUnits.gram),
      "kg" => Unit(UnitCategory.weightunit, WeightUnits.kilogram),
      "oz" => Unit(UnitCategory.weightunit, WeightUnits.ounce),
      "lbs" => Unit(UnitCategory.weightunit, WeightUnits.pound),
      "sb" => Unit(UnitCategory.specialunit, SpecialUnits.stickOfButter),
      "egg" => Unit(UnitCategory.specialunit, SpecialUnits.eggSizes),
      "sht" => Unit(UnitCategory.specialunit, SpecialUnits.sheet),
      _ => throw FormatException("Can't assign string: $unit to a known unit"),
    };
  }
}

Unit getUnitFromString(String unitString) {
  unitString = unitString.toLowerCase();
  switch (unitString) {
    case "wholeunit":
      return Unit(UnitCategory.wholeunit, WholeItemsUnits.bottle);
    case "volumeunit":
      return Unit(UnitCategory.volumeunit, VolumeUnits.teaspoon);
    case "weightunit":
      return Unit(UnitCategory.weightunit, WeightUnits.gram);
    case "specialunit":
      return Unit(UnitCategory.specialunit, SpecialUnits.stickOfButter);
    default:
      return Unit(UnitCategory.wholeunit, WholeItemsUnits.piece);
      throw ArgumentError('Unsupported unit string: $unitString');
  }
}
