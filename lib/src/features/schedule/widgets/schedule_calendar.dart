import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/ui/constants.dart';
import '../../../core/ui/helpers/messages.dart';

final class ScheduleCalendar extends StatefulWidget {
  final ValueChanged<DateTime> okPressed;
  final VoidCallback cancelPressed;
  final List<String> workDays;

  const ScheduleCalendar({
    required this.okPressed,
    required this.cancelPressed,
    required this.workDays,
    super.key,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  final _selectedDay = ValueNotifier<DateTime?>(null);
  late final List<int> _enabledWeekDays;

  void _onPressedOk(DateTime? selectedDayValue) {
    if (selectedDayValue == null) {
      context.showError('Por favor, selecione uma data');

      return;
    }
    widget.okPressed(selectedDayValue);
  }

  int convertWeekDay(String weekday) => switch (weekday.toLowerCase()) {
        'seg' => DateTime.monday,
        'ter' => DateTime.tuesday,
        'qua' => DateTime.wednesday,
        'qui' => DateTime.thursday,
        'sex' => DateTime.friday,
        'sab' => DateTime.saturday,
        'dom' => DateTime.sunday,
        _ => 0,
      };

  @override
  void initState() {
    super.initState();
    _enabledWeekDays = widget.workDays.map(convertWeekDay).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFFE6E2E9),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _selectedDay,
            builder: (_, selectedDayValue, __) => TableCalendar<void>(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2010),
              lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
              locale: 'pt_BR',
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              availableGestures: AvailableGestures.none,
              headerStyle: const HeaderStyle(titleCentered: true),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: ColorConstants.brown.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: ColorConstants.brown,
                  shape: BoxShape.circle,
                ),
              ),
              enabledDayPredicate: (day) =>
                  _enabledWeekDays.contains(day.weekday),
              selectedDayPredicate: (day) => isSameDay(selectedDayValue, day),
              onDaySelected: (selectedDay, _) =>
                  _selectedDay.value = selectedDay,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.cancelPressed,
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: ColorConstants.brown,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _selectedDay,
                builder: (_, selectedDayValue, __) => TextButton(
                  onPressed: () => _onPressedOk(selectedDayValue),
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      color: ColorConstants.brown,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
