import 'package:client/model/allergens.dart';

class User {
  String email;
  List<Allergens> allergens;

  User(this.email, this.allergens);
}
