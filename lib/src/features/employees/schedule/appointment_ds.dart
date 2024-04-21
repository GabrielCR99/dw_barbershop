import 'package:syncfusion_flutter_calendar/calendar.dart';

final class AppointmentDs extends CalendarDataSource {
  @override
  List<Object>? get appointments => [
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          subject: 'Reunião',
        ),
        Appointment(
          startTime: DateTime.now().add(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 3)),
        ),
      ];
}
