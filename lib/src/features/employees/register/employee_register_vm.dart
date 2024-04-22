import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/repository_exception.dart';
import '../../../core/fp/either.dart';
import '../../../core/fp/nil.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/barbershop_model.dart';
import '../../../repositories/user/user_repository.dart';
import 'employee_register_state.dart';

part 'employee_register_vm.g.dart';

@riverpod
final class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterADM({required bool isRegisterAdm}) =>
      state = state.copyWith(registerAdm: isRegisterAdm);

  void addOrRemoveWorkdays(String day) {
    final workDays = state.workdays;

    if (workDays.contains(day)) {
      workDays.remove(day);
    } else {
      workDays.add(day);
    }

    state = state.copyWith(workdays: workDays);
  }

  void addOrRemoveWorkHours(int hour) {
    final workHours = state.workHours;

    if (workHours.contains(hour)) {
      workHours.remove(hour);
    } else {
      workHours.add(hour);
    }

    state = state.copyWith(workHours: workHours);
  }

  Future<void> register({String? name, String? email, String? password}) async {
    final EmployeeRegisterState(:registerAdm, :workHours, :workdays) = state;
    final asyncLoaderHandler = AsyncLoaderHandler.start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

    final Either<RepositoryException, Nil> result;

    if (registerAdm) {
      final dto = (workdays: workdays, workHours: workHours);
      result = await registerAdmAsEmployee(dto);
    } else {
      final BarbershopModel(:id) =
          await ref.watch(getMyBarbershopProvider.future);
      final dto = (
        barberShopId: id,
        name: name!,
        email: email!,
        password: password!,
        workdays: workdays,
        workHours: workHours,
      );
      result = await registerEmployee(dto);
    }

    switch (result) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStatus.success);
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStatus.error);
    }
    asyncLoaderHandler.close();
  }
}
