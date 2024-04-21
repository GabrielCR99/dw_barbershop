import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/local_storage_keys.dart';
import '../../core/providers/application_providers.dart';
import '../../models/user_model.dart';

part 'splash_vm.g.dart';

enum SplashState {
  initial,
  login,
  admLogged,
  employeeLogged,
  error;
}

@riverpod
final class SplashVm extends _$SplashVm {
  @override
  Future<SplashState> build() async {
    final sp = await SharedPreferences.getInstance();

    if (sp.containsKey(LocalStorageKeys.accessToken)) {
      try {
        ref
          ..invalidate(getMeProvider)
          ..invalidate(getMyBarbershopProvider);

        final userModel = await ref.watch(getMeProvider.future);

        return switch (userModel) {
          UserModelAdm() => SplashState.admLogged,
          UserModelEmployee() => SplashState.employeeLogged,
        };
      } catch (_) {
        return SplashState.error;
      }
    }

    return SplashState.login;
  }
}
