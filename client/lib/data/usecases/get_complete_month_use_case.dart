import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/model/month.dart';

class GetCompleteMonthUseCase {
  CalendarRepository calendarRepository;
  int monthCount;

  GetCompleteMonthUseCase(this.calendarRepository, this.monthCount);

  Future<Month> execute() async {
    return calendarRepository.getCompleteMonth(monthCount);
  }
}
