import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/ui/constants.dart';
import 'appointment_ds.dart';

final class EmployeeSchedulePage extends StatelessWidget {
  const EmployeeSchedulePage({super.key});

  void _onTapCalendar(
    CalendarTapDetails calendarTapDetails,
    BuildContext context,
  ) {
    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments!.isNotEmpty) {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cliente: '
                    '${calendarTapDetails.appointments?.first.subject}',
                  ),
                  Text(
                    'Horário: ${dateFormat.format(calendarTapDetails.date!)}',
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: Column(
        children: [
          const Text(
            'Nome e sobrenome',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 44),
          Expanded(
            child: SfCalendar(
              todayHighlightColor: ColorConstants.brown,
              dataSource: AppointmentDs(),
              onTap: (calendarTapDetails) =>
                  _onTapCalendar(calendarTapDetails, context),
              appointmentBuilder: (_, calendarAppointmentDetails) =>
                  DecoratedBox(
                decoration: const BoxDecoration(
                  color: ColorConstants.brown,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    calendarAppointmentDetails.appointments.first.subject
                        as String,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              showNavigationArrow: true,
              showDatePickerButton: true,
              showTodayButton: true,
              allowViewNavigation: true,
            ),
          ),
        ],
      ),
    );
  }
}
