import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/providers/application_providers.dart';
import '../../models/user_model.dart';
import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
final class LoginVm extends _$LoginVm {
  @override
  LoginState build() => const LoginState.initial();

  Future<void> login({required String email, required String password}) async {
    final loaderHandler = AsyncLoaderHandler()..start();

    final service = ref.watch(userLoginServiceProvider);
    final result = await service.execute(email: email, password: password);

    switch (result) {
      case Success():
        ref
          ..invalidate(getMeProvider)
          ..invalidate(getMyBarbershopProvider);

        final userModel = await ref.read(getMeProvider.future);

        switch (userModel) {
          case UserModelAdm():
            state = state.copyWith(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatus.employeeLogin);
        }
      case Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandler.close();
  }
}
