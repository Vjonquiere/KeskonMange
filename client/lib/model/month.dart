class PlannedRecipe {
  String date;
  int recipeId;
  int done;
  String resultImage;

  PlannedRecipe(this.date, this.recipeId, this.done, this.resultImage);

  factory PlannedRecipe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "date": String date,
        "recipeId": int recipeId,
        "done": int done,
        "result_img": String resultImage,
      } =>
        PlannedRecipe(date, recipeId, done, resultImage),
      _ => throw const FormatException('Failed to load PlannedRecipe.'),
    };
  }

  int getDay() {
    return int.parse(date.split("-")[2]);
  }
}

class Month {
  int year;
  int month;
  List<PlannedRecipe> plannedRecipes;
  List<List<int>> monthTemplate;
  final List<String> days = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];

  Month(this.year, this.month, this.plannedRecipes, this.monthTemplate);

  factory Month.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "year": int year,
        "month": int month,
        "recipes": List recipesJson,
        "monthTemplate": List monthTemplateJson,
      } =>
        Month(
          year,
          month,
          recipesJson
              .map((recipe) =>
                  PlannedRecipe.fromJson(recipe as Map<String, dynamic>))
              .toList(),
          monthTemplateJson.map((e) => List<int>.from(e as List)).toList(),
        ),
      _ => throw const FormatException('Failed to load Month.'),
    };
  }
}
