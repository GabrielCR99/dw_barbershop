import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/ui/constants.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../../../models/user_model.dart';
import 'appointment_ds.dart';
import 'employee_schedule_vm.dart';

final class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

final class _EmployeeSchedulePageState
    extends ConsumerState<EmployeeSchedulePage> {
  late final DateTime _selectedDate;
  var _ignoreFirstLoad = true;

  @override
  void initState() {
    super.initState();
    final DateTime(:year, :month, :day) = DateTime.now();
    _selectedDate = DateTime(year, month, day);
  }

  void _onTapCalendar(
    CalendarTapDetails calendarTapDetails,
    BuildContext context,
  ) {
    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments!.isNotEmpty) {
      showModalBottomSheet<void>(
        context: context,
        builder: (_) {
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
    final UserModel(:id, :name) =
        ModalRoute.of(context)!.settings.arguments! as UserModel;
    final asyncSchedule =
        ref.watch(employeeScheduleVmProvider(id, _selectedDate));

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 44),
          asyncSchedule.when(
            data: (data) => Expanded(
              child: SfCalendar(
                todayHighlightColor: ColorConstants.brown,
                dataSource: AppointmentDs(schedules: data),
                onViewChanged: (viewChangedDetails) =>
                    _onViewChanged(id, viewChangedDetails),
                onTap: (calendarTapDetails) =>
                    _onTapCalendar(calendarTapDetails, context),
                showNavigationArrow: true,
                showDatePickerButton: true,
                showTodayButton: true,
                allowViewNavigation: true,
              ),
            ),
            error: (error, stackTrace) {
              log('Error: $error', error: error, stackTrace: stackTrace);

              return const Text('Erro ao carregar a agenda');
            },
            loading: BarbershopLoader.new,
          ),
        ],
      ),
    );
  }

  void _onViewChanged(int id, ViewChangedDetails viewChangedDetails) {
    if (_ignoreFirstLoad) {
      _ignoreFirstLoad = false;

      return;
    }

    ref
        .read(employeeScheduleVmProvider(id, _selectedDate).notifier)
        .changeDate(id, viewChangedDetails.visibleDates.first);
  }
}
