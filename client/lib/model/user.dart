import 'allergen.dart';

class User {
  String email;
  String username;
  List<Allergen> allergens;

  User(this.email, this.username, this.allergens);

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': final String email,
        'username': final String username,
        'allergens': final List<dynamic> allergens
      } =>
        User(email, username, <Allergen>[]), // TODO: allergens
      _ => throw const FormatException('Failed to load user.')
    };
  }
}
