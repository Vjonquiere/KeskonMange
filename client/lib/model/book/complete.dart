import 'package:client/model/book/preview.dart';

import '../../features/home/widgets/recipe_preview.dart';

class Book extends BookPreview {
  List<int> recipesIds;
  Book(super.id, super.name, super.creationDate, super.owner, super.public,
      this.recipesIds);
}
