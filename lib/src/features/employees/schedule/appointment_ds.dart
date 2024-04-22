import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/ui/constants.dart';
import '../../../models/schedule_model.dart';

final class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;

  AppointmentDs({required this.schedules});

  @override
  List<Object>? get appointments => schedules.map((e) {
        final ScheduleModel(
          date: DateTime(:year, :month, :day),
          :hour,
          :clientName,
        ) = e;
        final startTime = DateTime(year, month, day, hour);
        final endTime = DateTime(year, month, day, hour + 1);

        return Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: clientName,
          color: ColorConstants.brown,
        );
      }).toList();
}
