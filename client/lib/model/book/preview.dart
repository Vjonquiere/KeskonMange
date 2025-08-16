import '../user.dart';

class BookPreview {
  int id;
  String name;
  DateTime creationDate;
  int ownerId;
  bool public;

  BookPreview(this.id, this.name, this.creationDate, this.ownerId, this.public);

  factory BookPreview.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'creationDate': String creationDate,
        'owner': int owner,
        'public': bool public
      } =>
        BookPreview(id, name, DateTime.parse(creationDate), owner, public),
      _ => throw const FormatException('Failed to load book.')
    };
  }
}
