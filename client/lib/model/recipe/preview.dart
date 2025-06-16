class RecipePreview {
  int id;
  final String title;
  final String type;
  final int difficulty;
  final int cost;
  final int vegetarian;
  final int vegan;
  final int hasGluten;
  final int hasLactose;
  final int hasPork;
  final int salty;
  final int sweet;
  final int preparationTime;
  final int restTime;
  final int cookTime;
  final int owner;
  final int public;

  RecipePreview(
      this.id,
      this.title,
      this.type,
      this.difficulty,
      this.cost,
      this.vegetarian,
      this.vegan,
      this.hasGluten,
      this.hasLactose,
      this.hasPork,
      this.salty,
      this.sweet,
      this.preparationTime,
      this.restTime,
      this.cookTime,
      this.owner,
      this.public);

  factory RecipePreview.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'type': String type,
        'difficulty': int difficulty,
        'cost': int cost,
        'vegetarian': int vegetarian,
        'vegan': int vegan,
        'hasGluten': int hasGluten,
        'hasLactose': int hasLactose,
        'hasPork': int hasPork,
        'salty': int salty,
        'sweet': int sweet,
        'preparation': int preparation,
        'rest': int rest,
        'cook': int cook,
        'owner': int owner,
        'public': int public
      } =>
        RecipePreview(
            id,
            title,
            type,
            difficulty,
            cost,
            vegetarian,
            vegan,
            hasGluten,
            hasLactose,
            hasPork,
            salty,
            sweet,
            preparation,
            rest,
            cook,
            owner,
            public),
      _ => throw const FormatException('Failed to load recipe.'),
    };
  }
}
