enum Allergen {
  gluten,
  fish,
  peanuts,
  celery,
  sulfates,
  lupin,
  eggs,
  sesame,
  mustard,
  mollusks,
  crustaceans,
  soy,
  nuts,
  milk;

  factory Allergen.fromString(String allergenString) {
    for (final Allergen allergen in Allergen.values) {
      if (allergen.toString() == allergenString) {
        return allergen;
      }
    }
    throw Exception("$allergenString isn't an known allergen");
  }
}
