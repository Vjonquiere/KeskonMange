import 'package:client/core/ViewModel.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/book/preview.dart';
import 'package:client/model/user.dart';

class MyCreationViewModel extends ViewModel {
  List<BookPreview> _books = [];

  List<BookPreview> get books => _books;
  int get booksCount => _books.length;

  MyCreationViewModel() {
    getUserBooks();
  }

  Future<void> getUserBooks() async {
    setStateValue(WidgetStates.idle);
    notifyListeners();
    _books = await RepositoriesManager()
        .getBookRepository()
        .getUserBooks(User("p", "r", []));
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }
}
