import 'package:client/data/repositories/calendar_repository.dart';
import 'package:client/model/month.dart';

class GetCompleteMonthUseCase {
  CalendarRepository calendarRepository;

  GetCompleteMonthUseCase(this.calendarRepository);

  Future<Month> execute() async {
    return Month(2025, 12, [], []);
  }
}
