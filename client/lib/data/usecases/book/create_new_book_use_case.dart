import 'package:client/data/repositories/book_repository.dart';
import '../../../model/book/preview.dart';

class CreateNewBookUseCase {
  final BookRepository _bookRepository;
  BookPreview book;

  CreateNewBookUseCase(this._bookRepository, this.book);

  Future<int> execute() {
    return _bookRepository.createNewBook(book);
  }
}
