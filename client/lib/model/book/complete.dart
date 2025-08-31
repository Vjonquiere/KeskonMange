import 'package:client/model/book/preview.dart';

class Book extends BookPreview {
  List<int> recipesIds;
  Book(
    super.id,
    super.name,
    super.creationDate,
    super.owner,
    super.public,
    this.recipesIds,
  );

  factory Book.fromPreview(BookPreview preview) {
    return Book(
      preview.id,
      preview.name,
      preview.creationDate,
      -1,
      preview.public,
      <int>[],
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'name': final String name,
        'creationDate': final String creationDate,
        'owner': final int owner,
        'public': final bool public,
        'recipes': final List<dynamic> recipes,
      } =>
        Book(
          id,
          name,
          DateTime.parse(creationDate),
          owner,
          public,
          recipes.map((e) => e as int).toList(),
        ),
      _ => throw const FormatException('Failed to load book.')
    };
  }

  @override
  String toString() {
    return "Book => {id:$id, name:$name, creationDate:$creationDate, numberOfRecipes:$recipesIds}";
  }
}
