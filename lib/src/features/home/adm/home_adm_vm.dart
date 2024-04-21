import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/repository_exception.dart';
import '../../../core/fp/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/barbershop_model.dart';
import '../../../models/user_model.dart';
import 'home_adm_status.dart';

part 'home_adm_vm.g.dart';

@riverpod
final class HomeAdm extends _$HomeAdm {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final BarbershopModel(:id) = await ref.read(getMyBarbershopProvider.future);
    final [
      me as UserModel,
      employeesResult as Either<RepositoryException, List<UserModel>>
    ] = await Future.wait(
      [ref.watch(getMeProvider.future), repository.getEmployees(id)],
    );

    switch (employeesResult) {
      case Success(:final value):
        final employees = <UserModel>[];
        if (me case UserModelAdm(workDays: _?, workHours: _?)) {
          employees.add(me);
        }
        employees.addAll(value);

        return HomeAdmState(employees: value, status: HomeAdmStatus.loaded);
      case Failure():
        return const HomeAdmState(employees: [], status: HomeAdmStatus.error);
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
