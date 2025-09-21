import 'package:client/features/recipe_search/widgets/ingredient_filter/ingredient_filter.dart';
import 'package:client/features/recipe_search/widgets/preparation_time_filer/preparation_time_filter.dart';
import 'package:flutter/cupertino.dart';

enum Filters {
  ingredient,
  preparationTime,
  cookingTime,
}

extension FiltersWidgets on Filters {
  Widget get widget {
    return switch (this) {
      Filters.ingredient => IngredientFilter(),
      Filters.preparationTime => PreparationTimeFilter(),
      Filters.cookingTime => throw UnimplementedError(),
    };
  }
}

abstract class Filter {
  String toJson();
}
