import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/barbershop_icons.dart';
import '../../core/ui/constants.dart';
import '../../core/ui/helpers/form_helper.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/helpers/navigator_helper.dart';
import '../../core/ui/widgets/avatar_widget.dart';
import '../../core/ui/widgets/hours_panel.dart';
import '../../models/user_model.dart';
import 'schedule_state.dart';
import 'schedule_vm.dart';
import 'widgets/schedule_calendar.dart';

final class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

final class _SchedulePageState extends ConsumerState<SchedulePage> {
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _showCalendar = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  final _clientEC = TextEditingController();
  final _dateEC = TextEditingController();

  void _onTapDate() {
    _showCalendar.value = true;
    context.unfocus();
  }

  void _okPressed(DateTime value) {
    _dateEC.text = _dateFormat.format(value);
    ref.watch(scheduleVmProvider.notifier).selectDate(value);
    _showCalendar.value = false;
  }

  void _scheduleClient(UserModel userModel) {
    final hourSelected = ref.watch(
      scheduleVmProvider.select((value) => value.scheduleHour != null),
    );

    if (hourSelected) {
      ref
          .watch(scheduleVmProvider.notifier)
          .register(userModel: userModel, clientName: _clientEC.text);
    } else {
      context.showError('Por favor, selecione um horário de atendimento!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments! as UserModel;
    final scheduleVm = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelAdm(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays,
          workHours: workHours,
        ),
    };

    ref.listen(
      scheduleVmProvider.select((state) => state.status),
      (_, status) => switch (status) {
        ScheduleStateStatus.success => context
          ..showSuccess('Cliente agendado com sucesso')
          ..pop<void>(),
        ScheduleStateStatus.error =>
          context.showError('Erro ao agendar cliente'),
        _ => null,
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cliente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Center(
              child: AvatarWidget(hideUploadButton: true),
            ),
            const SizedBox(height: 24),
            Text(
              userModel.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 37),
            TextFormField(
              controller: _clientEC,
              decoration: const InputDecoration(label: Text('Cliente')),
              validator: Validatorless.required('Cliente obrigatório'),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _dateEC,
              decoration: const InputDecoration(
                label: Text('Selecione uma data'),
                hintText: 'Selecione uma data',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: Icon(
                  BarbershopIcons.calendar,
                  size: 18,
                  color: ColorConstants.brown,
                ),
              ),
              readOnly: true,
              onTap: _onTapDate,
              validator: Validatorless.required('Data obrigatória'),
            ),
            ValueListenableBuilder(
              valueListenable: _showCalendar,
              builder: (_, showCalendarValue, __) => Offstage(
                offstage: !showCalendarValue,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    ScheduleCalendar(
                      okPressed: _okPressed,
                      cancelPressed: () => _showCalendar.value = false,
                      workDays: employeeData.workDays,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            HoursPanel.singleSelection(
              startTime: 6,
              endTime: 23,
              onTimePressed: scheduleVm.selectHour,
              enabledTimes: employeeData.workHours,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => switch (_formKey.currentState?.validate()) {
                null || false => context.showError('Dados incompletos'),
                true => _scheduleClient(userModel),
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Agendar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _showCalendar.dispose();
    _clientEC.dispose();
    _dateEC.dispose();
    super.dispose();
  }
}
