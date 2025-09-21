import 'package:client/features/recipe_search/model/filters.dart';

class PreparationTimeFilter extends Filter {
  final int preparationTime;

  PreparationTimeFilter({required this.preparationTime});

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
