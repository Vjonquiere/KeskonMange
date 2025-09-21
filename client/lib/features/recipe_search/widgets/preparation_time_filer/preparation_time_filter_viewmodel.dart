import 'package:client/core/view_model.dart';

class PreparationTimeFilterViewModel extends ViewModel {
  double _currentTime = 5.0;

  double get currentTime => _currentTime;

  void updateCurrentTime(double value) {
    _currentTime = value;
    notifyListeners();
  }

  String convertedCurrentTime() {
    if (_currentTime == 180) {
      return "+3h";
    }
    final int totalMinutes = _currentTime.round();
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    if (hours <= 0) {
      return "${minutes}min";
    }
    return "${hours}h${minutes}min";
  }
}
