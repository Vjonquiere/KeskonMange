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
      "pc" || "piece" => Unit(UnitCategory.wholeunit, WholeItemsUnits.piece),
      "clv" || "clove" => Unit(UnitCategory.wholeunit, WholeItemsUnits.clove),
      "slc" || "slice" => Unit(UnitCategory.wholeunit, WholeItemsUnits.slice),
      "stk" || "stick" => Unit(UnitCategory.wholeunit, WholeItemsUnits.stick),
      "hd" || "head" => Unit(UnitCategory.wholeunit, WholeItemsUnits.head),
      "lf" || "leaf" => Unit(UnitCategory.wholeunit, WholeItemsUnits.leaf),
      "cn" || "can" => Unit(UnitCategory.wholeunit, WholeItemsUnits.can),
      "btl" || "bottle" => Unit(UnitCategory.wholeunit, WholeItemsUnits.bottle),
      "jr" || "jar" => Unit(UnitCategory.wholeunit, WholeItemsUnits.jar),
      "pkg" ||
      "package" =>
        Unit(UnitCategory.wholeunit, WholeItemsUnits.package),
      "bx" || "box" => Unit(UnitCategory.wholeunit, WholeItemsUnits.box),
      "bnch" || "bunch" => Unit(UnitCategory.wholeunit, WholeItemsUnits.bunch),
      "tsp" ||
      "teaspoon" =>
        Unit(UnitCategory.volumeunit, VolumeUnits.teaspoon),
      "tbsp" ||
      "tablespoon" =>
        Unit(UnitCategory.volumeunit, VolumeUnits.tablespoon),
      "floz" ||
      "fluidOunce" =>
        Unit(UnitCategory.volumeunit, VolumeUnits.fluidOunce),
      "c" || "cup" => Unit(UnitCategory.volumeunit, VolumeUnits.cup),
      "pt" || "pint" => Unit(UnitCategory.volumeunit, VolumeUnits.pint),
      "qt" || "quart" => Unit(UnitCategory.volumeunit, VolumeUnits.quart),
      "gal" || "gallon" => Unit(UnitCategory.volumeunit, VolumeUnits.gallon),
      "ml" ||
      "milliliter" =>
        Unit(UnitCategory.volumeunit, VolumeUnits.milliliter),
      "l" || "liter" => Unit(UnitCategory.volumeunit, VolumeUnits.liter),
      "g" || "gram" => Unit(UnitCategory.weightunit, WeightUnits.gram),
      "kg" || "kilogram" => Unit(UnitCategory.weightunit, WeightUnits.kilogram),
      "oz" || "ounce" => Unit(UnitCategory.weightunit, WeightUnits.ounce),
      "lbs" || "pound" => Unit(UnitCategory.weightunit, WeightUnits.pound),
      "sb" ||
      "stickOfButter" =>
        Unit(UnitCategory.specialunit, SpecialUnits.stickOfButter),
      "egg" ||
      "eggSizes" =>
        Unit(UnitCategory.specialunit, SpecialUnits.eggSizes),
      "sht" || "sheet" => Unit(UnitCategory.specialunit, SpecialUnits.sheet),
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
