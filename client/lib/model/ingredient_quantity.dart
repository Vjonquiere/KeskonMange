import 'ingredient_units.dart';

class IngredientQuantity {
  int ingredientId;
  Unit unit;
  double quantity;

  IngredientQuantity(this.ingredientId, this.unit, this.quantity);

  factory IngredientQuantity.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "ingredientId": final int ingredient,
        "quantity": final double quant,
        "unit": final String uni
      } =>
        IngredientQuantity(ingredient, Unit.fromString(uni), quant),
      _ => throw FormatException("Can't load ingredient quantity from Json")
    };
  }
}
