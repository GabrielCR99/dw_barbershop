import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/fp/either.dart';
import '../../core/providers/application_providers.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';
import 'schedule_state.dart';

part 'schedule_vm.g.dart';

@riverpod
final class ScheduleVm extends _$ScheduleVm {
  @override
  ScheduleState build() => ScheduleState.initial();

  void selectHour(int hour) => state = hour == state.scheduleHour
      ? state.copyWith(scheduleHour: () => null)
      : state.copyWith(scheduleHour: () => hour);

  void selectDate(DateTime date) =>
      state = state.copyWith(scheduleDate: () => date);

  Future<void> register({
    required UserModel userModel,
    required String clientName,
  }) async {
    final asyncLoaderHandler = AsyncLoaderHandler.start();
    final ScheduleState(:scheduleDate, :scheduleHour) = state;
    final scheduleRepository = ref.watch(scheduleRepositoryProvider);
    final BarbershopModel(:id) =
        await ref.watch(getMyBarbershopProvider.future);
    final dto = (
      barberShopId: id,
      userId: userModel.id,
      clientName: clientName,
      date: scheduleDate!,
      time: scheduleHour!,
    );

    final scheduleResut = await scheduleRepository.scheduleClient(dto);

    switch (scheduleResut) {
      case Success():
        state = state.copyWith(status: ScheduleStateStatus.success);
      case Failure():
        state = state.copyWith(status: ScheduleStateStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
