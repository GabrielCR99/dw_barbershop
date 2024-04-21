import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/service_exception.dart';
import '../../../core/fp/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/user_model.dart';
import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
final class LoginVm extends _$LoginVm {
  @override
  LoginState build() =>
      const (status: LoginStateStatus.initial, errorMessage: null);

  Future<void> login({required String email, required String password}) async {
    final service = ref.watch(userLoginServiceProvider);
    final result =
        await service.execute(email: email, password: password).asyncLoader();

    switch (result) {
      case Success():
        ref
          ..invalidate(getMeProvider)
          ..invalidate(getMyBarbershopProvider);

        final userModel = await ref.read(getMeProvider.future);

        switch (userModel) {
          case UserModelAdm():
            state =
                const (status: LoginStateStatus.admLogin, errorMessage: null);
          case UserModelEmployee():
            state = const (
              status: LoginStateStatus.employeeLogin,
              errorMessage: null
            );
        }
      case Failure(exception: ServiceException(:final message)):
        state = (status: LoginStateStatus.error, errorMessage: message);
    }
  }
}
