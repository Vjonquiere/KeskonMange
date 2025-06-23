import 'allergen.dart';

class User {
  String email;
  String username;
  List<Allergen> allergens;

  User(this.email, this.username, this.allergens);
}
