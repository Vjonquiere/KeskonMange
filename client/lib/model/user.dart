import 'allergen.dart';

class User {
  String email;
  String username;
  List<Allergen> allergens;

  User(this.email, this.username, this.allergens);

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email,
        'username': String username,
        'allergens': List<dynamic> allergens
      } =>
        User(email, username, []), // TODO: allergens
      _ => throw const FormatException('Failed to load user.')
    };
  }
}
