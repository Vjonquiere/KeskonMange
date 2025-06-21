import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/model/month.dart';

class GetCompleteMonthUseCase {
  final CalendarRepository _calendarRepository;
  int monthCount;

  GetCompleteMonthUseCase(this._calendarRepository, this.monthCount);

  Future<Month> execute() async {
    return _calendarRepository.getCompleteMonth(monthCount);
  }
}
