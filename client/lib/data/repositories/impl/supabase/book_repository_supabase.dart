import 'package:client/data/repositories/book_repository.dart';
import 'package:client/model/book/complete.dart';
import 'package:client/model/book/preview.dart';
import 'package:client/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as S;

class BookRepositorySupabase extends BookRepository {
  @override
  Future<int> addRecipeToBook(int bookId, int recipeId) async {
    await S.Supabase.instance.client.rest
        .from("book_recipe_link")
        .insert({"book_id": bookId, "recipe_id": recipeId});
    return 200;
  }

  @override
  Future<int> createNewBook(BookPreview book) async {
    await S.Supabase.instance.client.rest
        .from("books")
        .insert({"name": book.name, "public": book.public});
    return 200;
  }

  @override
  Future<int> deleteBook(int bookId) async {
    await S.Supabase.instance.client.rest
        .from("books")
        .delete()
        .eq("id", bookId);
    await S.Supabase.instance.client.rest
        .from("book_recipe_link")
        .delete()
        .eq("book_id", bookId);
    return 200;
  }

  @override
  Future<int> deleteRecipeFromBook(int bookId, int recipeId) async {
    await S.Supabase.instance.client.rest
        .from("book_recipe_link")
        .delete()
        .eq("book_id", bookId)
        .eq("recipe_id", recipeId);
    return 200;
  }

  @override
  Future<Book?> getBook(int bookId) async {
    final S.PostgrestList res = await S.Supabase.instance.client.rest
        .from("books")
        .select()
        .eq("id", bookId);
    throw UnimplementedError();
  }

  @override
  Future<List<BookPreview>> getUserBooks(User user) async {
    final S.PostgrestList res =
        await S.Supabase.instance.client.rest.from("books").select();
    return res.map((S.PostgrestMap e) => BookPreview.fromJson(e)).toList();
  }
}
