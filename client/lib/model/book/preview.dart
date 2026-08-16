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
        'id': final int id,
        'name': final String name,
        'creationDate': final String creationDate,
        'owner': final int owner,
        'public': final bool public
      } =>
        BookPreview(id, name, DateTime.parse(creationDate), owner, public),
      {
        'id': final int id,
        'name': final String name,
        'creation_date': final String creationDate,
        'owner': final String owner,
        'public': final bool public
      } =>
        BookPreview(id, name, DateTime.parse(creationDate), 1,
            public), // TODO: Set a common owner type between repos
      _ => throw FormatException('Failed to load book: ${json.toString()}}.')
    };
  }
}
