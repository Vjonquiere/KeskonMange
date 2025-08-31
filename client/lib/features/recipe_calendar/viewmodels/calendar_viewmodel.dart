import 'package:client/core/ViewModel.dart';
import 'package:client/core/widget_states.dart';
import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/month.dart';

import '../../../data/usecases/get_complete_month_use_case.dart';

class CalendarViewModel extends ViewModel {
  Month? _currentMonth;
  final _currentMonthUseCase =
      GetCompleteMonthUseCase(RepositoriesManager().getCalendarRepository(), 0);

  Month get currentMonth => _currentMonth!;

  CalendarViewModel() {
    getCurrentMonth();
  }

  Future<void> getCurrentMonth() async {
    _currentMonth =
        await RepositoriesManager().getCalendarRepository().getCompleteMonth(0);
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Future<void> nextMonth() async {
    if (_currentMonthUseCase.monthCount >= 0) return;
    _currentMonthUseCase.monthCount++;
    _currentMonth = await _currentMonthUseCase.execute();
    notifyListeners();
  }

  Future<void> previousMonth() async {
    _currentMonthUseCase.monthCount--;
    _currentMonth = await _currentMonthUseCase.execute();
    notifyListeners();
  }
}
