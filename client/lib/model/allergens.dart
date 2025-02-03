class Allergens {
  List<String> allergens;

  Allergens(this.allergens);

  factory Allergens.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'allergens': List<String> allergens,
      } =>
        Allergens(allergens),
      _ => throw const FormatException('Failed to load allergens.'),
    };
  }
}
