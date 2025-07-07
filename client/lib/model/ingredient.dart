class Ingredient {
  final String name;

  Ingredient(this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
      } =>
        Ingredient(name),
      _ => throw const FormatException('Failed to load ingredient.'),
    };
  }
}
