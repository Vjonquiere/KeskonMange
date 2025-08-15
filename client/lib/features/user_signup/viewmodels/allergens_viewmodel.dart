import 'package:client/core/state_viewmodel.dart';

class AllergensViewModel extends StateViewModel {
  final List<bool> _selected = List.generate(14, (_) => false);

  List<bool> get selected => _selected;

  @override
  Future<bool> isValid() async {
    return true;
  }

  void onSelectedSwitch(int index, bool selected) {
    _selected[index] = selected;
    notifyListeners();
  }
}
