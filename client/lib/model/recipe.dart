class RecipeRestrictions{
  final int vegetarian;
  final int vegan;
  final int hasGluten;
  final int hasLactose;
  final int hasPork;
  final int salty;
  final int sweet;

  RecipeRestrictions(this.vegetarian, this.vegan, this.hasGluten, this.hasLactose, this.hasPork, this.salty, this.sweet);
}

class RecipeTime{
  final int preparation;
  final int rest;
  final int cook;
  RecipeTime(this.preparation, this.rest, this.cook);
}

class Recipe {
  final int id;
  final String title;
  final String type;
  final int difficulty;
  final int cost;
  final int portions;
  final int owner;
  final int visibility;
  RecipeRestrictions? restrictions;

  Recipe(this.id, this.title, this.type, this.difficulty, this.cost, this.portions, this.owner, this.visibility, {this.restrictions});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      { // Build with restrictions
      'id': int id,
      'title': String title,
      'type': String type,
      'difficulty': int difficulty,
      'cost': int cost,
      'portions': int portions,
      'vegetarian': int vegetarian,
      'vegan': int vegan,
      'hasGluten': int hasGluten,
      'hasLactose': int hasLactose,
      'hasPork': int hasPork,
      'salty': int salty,
      'sweet': int sweet,
      'owner': int owner,
      'visibility': int visibility,
      } =>
          Recipe(
              id,
              title,
              type,
              difficulty,
              cost,
              portions,
              owner,
              visibility,
              restrictions: RecipeRestrictions(vegetarian, vegan, hasGluten, hasLactose, hasPork, salty, sweet)
          ),
      { // Build without restrictions
      'id': int id,
      'title': String title,
      'type': String type,
      'difficulty': int difficulty,
      'cost': int cost,
      'portions': int portions,
      'owner': int owner,
      'visibility': int visibility,
      } =>
          Recipe(
            id,
            title,
            type,
            difficulty,
            cost,
            portions,
            owner,
            visibility,
          ),
      _ => throw const FormatException('Failed to load recipe.'),
    };
  }
}