class PlannedRecipe {
  String date;
  int recipeId;
  int done;
  String resultImage;

  PlannedRecipe(this.date, this.recipeId, this.done, this.resultImage);

  factory PlannedRecipe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "date": final String date,
        "recipeId": final int recipeId,
        "done": final int done,
        "result_img": final String resultImage,
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
  final List<String> days = <String>["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];

  Month(this.year, this.month, this.plannedRecipes, this.monthTemplate);

  factory Month.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "year": final int year,
        "month": final int month,
        "recipes": final List recipesJson,
        "monthTemplate": final List monthTemplateJson,
      } =>
        Month(
          year,
          month,
          recipesJson
              .map((recipe) =>
                  PlannedRecipe.fromJson(recipe as Map<String, dynamic>),)
              .toList(),
          monthTemplateJson.map((e) => List<int>.from(e as List)).toList(),
        ),
      _ => throw const FormatException('Failed to load Month.'),
    };
  }
}
