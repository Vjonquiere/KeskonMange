import 'package:client/data/repositories/ingredient_repository.dart';
import 'package:client/model/ingredient.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../model/ingredient_units.dart';

class IngredientRepositorySupabase extends IngredientRepository {
  @override
  Future<int> createIngredient(Ingredient ingredient) async {
    try {
      PostgrestList res = await Supabase.instance.client.rest
          .from("ingredients")
          .insert({"name": ingredient.name}).select();
      if (res.isNotEmpty) {
        for (Unit unit in ingredient.type) {
          await Supabase.instance.client.rest
              .from("ingredients_units")
              .insert({"id": res.first["id"], "unit": unit.toString()});
        }
        return 200;
      }
      return 500;
    } on PostgrestException catch (e) {
      return e.code == "23505"
          ? 201
          : 500; // code 23505 => ingredient already in DB
    }
  }

  @override
  Future<List<Ingredient>> findByNameLike(String name) async {
    final List<Ingredient> ingredients = <Ingredient>[];
    final PostgrestList res = await Supabase.instance.client.rest
        .from("ingredients")
        .select("id, name, ingredients_units(unit)")
        .like("name", "%$name%")
        .limit(10);
    for (PostgrestMap item in res) {
      ingredients.add(Ingredient.fromJson(<String, dynamic>{
        "id": item["id"],
        "name": item["name"],
        "units":
            List.of(item["ingredients_units"]).map((e) => e["unit"]).toList()
      }));
    }
    return ingredients;
  }

  @override
  Future<Ingredient?> getIngredientFromId(int id) async {
    final PostgrestList res = await Supabase.instance.client.rest
        .from("ingredients")
        .select("id, name, ingredients_units(unit)")
        .eq("id", id);
    final PostgrestMap item = res.first;
    return Ingredient.fromJson(<String, dynamic>{
      "id": item["id"],
      "name": item["name"],
      "units": List.of(item["ingredients_units"]).map((e) => e["unit"]).toList()
    });
  }
}
