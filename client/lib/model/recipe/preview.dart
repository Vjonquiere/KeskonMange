class RecipePreview {
  int id;
  final String title;
  final String? image;
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
    this.image,
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
    this.public,
  );

  factory RecipePreview.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'title': final String title,
        'image': final String image,
        'type': final String type,
        'difficulty': final int? difficulty,
        'cost': final int cost,
        'vegetarian': final bool vegetarian,
        'vegan': final bool vegan,
        'has_gluten': final bool hasGluten,
        'has_lactose': final bool hasLactose,
        'has_pork': final bool hasPork,
        'salty': final bool salty,
        'sweet': final bool sweet,
        'preparation_time': final int preparation,
        'rest_time': final int rest,
        'cook_time': final int cook,
        'owner': final String owner,
        'public': final bool public
      } =>
        RecipePreview(
          id,
          title,
          image == "" ? null : image,
          type,
          difficulty ?? 0,
          cost,
          vegetarian ? 1 : 0,
          vegan ? 1 : 0,
          hasGluten ? 1 : 0,
          hasLactose ? 1 : 0,
          hasPork ? 1 : 0,
          salty ? 1 : 0,
          sweet ? 1 : 0,
          preparation,
          rest,
          cook,
          1,
          public ? 1 : 0,
        ),
      {
        'id': final int id,
        'title': final String title,
        'image': final String image,
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
          image == "" ? null : image,
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
          public,
        ),
      _ => throw FormatException('Failed to load recipe: $json.'),
    };
  }
}
