import 'package:client/model/book/preview.dart';

import '../../features/home/widgets/recipe_preview.dart';

class Book extends BookPreview {
  List<int> recipesIds;
  Book(super.id, super.name, super.creationDate, super.owner, super.public,
      this.recipesIds);

  factory Book.fromPreview(BookPreview preview) {
    return Book(
        preview.id, preview.name, preview.creationDate, -1, preview.public, []);
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'creationDate': String creationDate,
        'owner': int owner,
        'public': bool public,
        'recipes': List<dynamic> recipes,
      } =>
        Book(id, name, DateTime.parse(creationDate), owner, public,
            recipes.map((e) => e as int).toList()),
      _ => throw const FormatException('Failed to load book.')
    };
  }

  @override
  String toString() {
    return "Book => {id:$id, name:$name, creationDate:$creationDate, numberOfRecipes:$recipesIds}";
  }
}
