import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/fp/nil.dart';
import '../../../../core/ui/helpers/form_helper.dart';
import '../../../../core/ui/helpers/messages.dart';
import '../../../../core/ui/widgets/hours_panel.dart';
import '../../../../core/ui/widgets/weekdays_panel.dart';
import 'barbershop_register_state.dart';
import 'barbershop_register_vm.dart';

final class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

final class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BarbershopRegisterVm(
      :addOrRemoveOpeningDays,
      :addOrRemoveOpeningHours,
      :register,
    ) = ref.watch(barbershopRegisterVmProvider.notifier);

    ref.listen(
      barbershopRegisterVmProvider,
      (_, state) => switch (state.status) {
        BarbershopRegisterStateStatus.initial => const Nil(),
        BarbershopRegisterStateStatus.error =>
          context.showError('Erro ao cadastrar estabelecimento'),
        BarbershopRegisterStateStatus.success => Navigator.of(context)
            .pushNamedAndRemoveUntil('/home/adm', (_) => false),
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar estabelecimento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 5),
            TextFormField(
              controller: _nameEC,
              decoration: const InputDecoration(label: Text('Nome')),
              onTapOutside: (_) => context.unfocus(),
              validator: Validatorless.required('Nome obrigatório'),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailEC,
              decoration: const InputDecoration(label: Text('E-mail')),
              onTapOutside: (_) => context.unfocus(),
              validator: Validatorless.multiple([
                Validatorless.required('E-mail obrigatório'),
                Validatorless.email('E-mail inválido'),
              ]),
            ),
            const SizedBox(height: 24),
            WeekdaysPanel(
              onDayPressed: addOrRemoveOpeningDays,
            ),
            const SizedBox(height: 24),
            HoursPanel(
              startTime: 6,
              endTime: 23,
              onTimePressed: addOrRemoveOpeningHours,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => switch (_formKey.currentState?.validate()) {
                false || null => context.showError('Formulário inválido'),
                true => register(name: _nameEC.text, email: _emailEC.text),
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Cadastrar estabelecimento'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }
}
