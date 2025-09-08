import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum MealCourse { starter, main, dessert }

enum Meal { lunch, dinner }

class MealSlot {
  final Day _day;
  final Meal _meal;
  bool selected;

  MealSlot(this._day, this._meal, {this.selected = false});

  Day get day => _day;
  Meal get meal => _meal;
}

extension DayL10n on Day {
  String translate(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return switch (this) {
      Day.monday => l10n.monday,
      Day.tuesday => l10n.tuesday,
      Day.wednesday => l10n.wednesday,
      Day.thursday => l10n.thursday,
      Day.friday => l10n.friday,
      Day.saturday => l10n.saturday,
      Day.sunday => l10n.sunday,
    };
  }
}
