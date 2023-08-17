import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/fp/nil.dart';
import '../../../../core/ui/helpers/form_helper.dart';
import '../../../../core/ui/helpers/messages.dart';
import 'user_register_vm.dart';

final class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

final class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserRegisterVm(:register) =
        ref.watch(userRegisterVmProvider.notifier);

    ref.listen(
      userRegisterVmProvider,
      (_, state) => switch (state) {
        UserRegisterStateStatus.initial => const Nil(),
        UserRegisterStateStatus.success =>
          Navigator.of(context).pushNamed('/auth/register/barbershop'),
        UserRegisterStateStatus.error =>
          context.showError('Erro ao registrar usuário Administrador'),
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            const SizedBox(height: 20),
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
            TextFormField(
              controller: _passwordEC,
              decoration: const InputDecoration(label: Text('Senha')),
              obscureText: true,
              onTapOutside: (_) => context.unfocus(),
              validator: Validatorless.multiple([
                Validatorless.required('Senha obrigatória'),
                Validatorless.min(6, 'Senha deve ter no mínimo 6 caracteres'),
              ]),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(label: Text('Confirmar senha')),
              obscureText: true,
              onTapOutside: (_) => context.unfocus(),
              validator: Validatorless.multiple([
                Validatorless.required('Senha obrigatória'),
                Validatorless.compare(_passwordEC, 'Senhas não conferem'),
              ]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => switch (_formKey.currentState?.validate()) {
                null || false => null,
                true => register(
                    name: _nameEC.text,
                    email: _emailEC.text,
                    password: _passwordEC.text,
                  ),
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('CRIAR CONTA'),
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
    _passwordEC.dispose();
    super.dispose();
  }
}
