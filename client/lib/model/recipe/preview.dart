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
      this.public,);

  factory RecipePreview.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'title': final String title,
        'type': final String type,
        'difficulty': final int difficulty,
        'cost': final int cost,
        'vegetarian': final int vegetarian,
        'vegan': final int vegan,
        'hasGluten': final int hasGluten,
        'hasLactose': final int hasLactose,
        'hasPork': final int hasPork,
        'salty': final int salty,
        'sweet': final int sweet,
        'preparation': final int preparation,
        'rest': final int rest,
        'cook': final int cook,
        'owner': final int owner,
        'public': final int public
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
            public,),
      _ => throw const FormatException('Failed to load recipe.'),
    };
  }
}
