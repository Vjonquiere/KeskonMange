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

/*enum Units {
  WholeItemsUnits,
  VolumeUnits,
  WeightUnits,
  SpecialUnits,
}*/

sealed class Unit {}

class WholeUnit extends Unit {
  final WholeItemsUnits value;
  WholeUnit(this.value);

  @override
  String toString() {
    return "WholeUnit";
  }
}

class VolumeUnit extends Unit {
  final VolumeUnits value;
  VolumeUnit(this.value);

  @override
  String toString() {
    return "VolumeUnit";
  }
}

class WeightUnit extends Unit {
  final WeightUnits value;
  WeightUnit(this.value);

  @override
  String toString() {
    return "WeightUnit";
  }
}

class SpecialUnit extends Unit {
  final SpecialUnits value;
  SpecialUnit(this.value);

  @override
  String toString() {
    return "SpecialUnit";
  }
}

Unit getUnitFromEnum(Object enumValue) {
  if (enumValue is WholeItemsUnits) {
    return WholeUnit(enumValue);
  } else if (enumValue is VolumeUnits) {
    return VolumeUnit(enumValue);
  } else if (enumValue is WeightUnits) {
    return WeightUnit(enumValue);
  } else if (enumValue is SpecialUnits) {
    return SpecialUnit(enumValue);
  } else {
    throw ArgumentError('Unsupported enum type: $enumValue');
  }
}
