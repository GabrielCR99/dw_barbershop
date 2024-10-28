import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/helpers/navigator_helper.dart';
import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../../../core/ui/widgets/hours_panel.dart';
import '../../../core/ui/widgets/weekdays_panel.dart';
import '../../../models/barbershop_model.dart';
import 'employee_register_state.dart';
import 'employee_register_vm.dart';

final class EmployeesRegisterPage extends ConsumerStatefulWidget {
  const EmployeesRegisterPage({super.key});

  @override
  ConsumerState<EmployeesRegisterPage> createState() =>
      _EmployeesRegisterPageState();
}

class _EmployeesRegisterPageState extends ConsumerState<EmployeesRegisterPage> {
  final _registerAdm = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  void _register() {
    final EmployeeRegisterState(
      workHours: List(isNotEmpty: hasWorkHours),
      workdays: List(isNotEmpty: hasWorkDays)
    ) = ref.watch(employeeRegisterVmProvider);

    if (!hasWorkDays || !hasWorkHours) {
      context.showError('Selecione os dias e horários de trabalho');

      return;
    }

    final (name, email, password) =
        (_nameEC.text, _emailEC.text, _passwordEC.text);
    ref
        .read(employeeRegisterVmProvider.notifier)
        .register(name: name, email: email, password: password);
  }

  void _onPressedCheckbox(bool? value) {
    _registerAdm.value = value!;
    ref
        .read(employeeRegisterVmProvider.notifier)
        .setRegisterADM(isRegisterAdm: value);
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barberShopModelAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(
      employeeRegisterVmProvider.select((state) => state.status),
      (_, status) => switch (status) {
        EmployeeRegisterStatus.success => context
          ..showSuccess('Colaborador cadastrado com sucesso')
          ..pop<void>(),
        EmployeeRegisterStatus.error =>
          context.showError('Erro ao cadastrar colaborador'),
        _ => null,
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar colaborador')),
      body: barberShopModelAsyncValue.when(
        data: (data) {
          final BarbershopModel(:openDays, :openHours) = data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(child: AvatarWidget()),
              const SizedBox(height: 32),
              Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _registerAdm,
                    builder: (_, registerAdmValue, __) => Checkbox.adaptive(
                      value: registerAdmValue,
                      onChanged: _onPressedCheckbox,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Sou administrador e quero me cadastrar como colaborador',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: ValueListenableBuilder(
                  valueListenable: _registerAdm,
                  builder: (_, registerAdmValue, __) => Offstage(
                    offstage: registerAdmValue,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameEC,
                          decoration:
                              const InputDecoration(label: Text('Nome')),
                          validator: registerAdmValue
                              ? null
                              : Validatorless.required('Nome obrigatório'),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailEC,
                          decoration:
                              const InputDecoration(label: Text('Email')),
                          validator: registerAdmValue
                              ? null
                              : Validatorless.multiple([
                                  Validatorless.required('Email obrigatório'),
                                  Validatorless.email('Email inválido'),
                                ]),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordEC,
                          decoration:
                              const InputDecoration(label: Text('Senha')),
                          obscureText: true,
                          validator: registerAdmValue
                              ? null
                              : Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(6, 'Senha muito curta'),
                                ]),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              WeekdaysPanel(
                onDayPressed: employeeRegisterVm.addOrRemoveWorkdays,
                enabledDays: openDays,
              ),
              const SizedBox(height: 24),
              HoursPanel(
                startTime: 6,
                endTime: 23,
                onTimePressed: employeeRegisterVm.addOrRemoveWorkHours,
                enabledTimes: openHours,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => switch (_formKey.currentState?.validate()) {
                  (false || null) =>
                    context.showError('Preencha os campos obrigatórios'),
                  true => _register(),
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text('CADASTRAR COLABORADOR'),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log('Error: $error', stackTrace: stackTrace);

          return const Center(
            child: Text(
              'Erro ao carregar dados da barbearia',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
        loading: BarbershopLoader.new,
      ),
    );
  }

  @override
  void dispose() {
    _registerAdm.dispose();
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }
}
