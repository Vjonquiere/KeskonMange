import 'dart:math';

import 'package:client/features/recipe_search/model/cooking_time_filter.dart';
import 'package:client/features/recipe_search/model/preparation_time_filter.dart';
import 'package:client/features/recipe_search/widgets/ingredient_filter/ingredient_filter.dart';
import 'package:flutter/cupertino.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/time_filer/time_filter.dart';

enum FilterType {
  ingredient,
  preparationTime,
  cookingTime,
}

extension FiltersWidgets on FilterType {
  Widget get widget {
    return switch (this) {
      FilterType.ingredient => IngredientFilter(),
      FilterType.preparationTime => TimeFilter(filter: PreparationTimeFilter(),),
      FilterType.cookingTime => TimeFilter(filter: CookingTimeFilter(),),
    };
  }
}

extension FiltersL10n on FilterType {
  String translate(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return switch (this) {
      FilterType.ingredient => l10n.ingredient_filter,
      FilterType.preparationTime => l10n.preparation_time_filter,
      FilterType.cookingTime => l10n.cooking_time_filter,
    };
  }
}

abstract class Filter {
  bool active = false;
  String toJson();
}
