import 'ingredient_units.dart';

class IngredientQuantity {
  int ingredientId;
  Unit unit;
  double quantity;

  IngredientQuantity(this.ingredientId, this.unit, this.quantity);

  factory IngredientQuantity.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "ingredient_id": final int ingredient,
        "quantity": final double quant,
        "unit": final String uni
      } =>
        IngredientQuantity(ingredient, Unit.fromString(uni), quant),
      {
        "ingredient_id": final int ingredient,
        "quantity": final int quant,
        "unit": final String uni
      } =>
        IngredientQuantity(ingredient, Unit.fromString(uni), quant.toDouble()),
      _ => throw FormatException("Can't load ingredient quantity: $json")
    };
  }
}
