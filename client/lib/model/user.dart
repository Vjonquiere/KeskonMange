import 'package:client/model/allergens.dart';

class User {
  String email;
  String username;
  List<Allergens> allergens;

  User(this.email, this.username, this.allergens);
}
