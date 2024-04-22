import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/repository_exception.dart';
import '../../../core/fp/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/schedule_model.dart';

part 'employee_schedule_vm.g.dart';

@riverpod
final class EmployeeScheduleVm extends _$EmployeeScheduleVm {
  @override
  Future<List<ScheduleModel>> build(int userId, DateTime date) async {
    final repository = ref.read(scheduleRepositoryProvider);
    final scheduleListResult =
        await repository.findScheduleByDate((userId: userId, date: date));

    return switch (scheduleListResult) {
      Success(:final value) => value,
      Failure(:final exception) => throw Exception(exception),
    };
  }

  Future<Either<RepositoryException, List<ScheduleModel>>> _getSchedules(
    int userId,
    DateTime date,
  ) =>
      ref
          .read(scheduleRepositoryProvider)
          .findScheduleByDate((userId: userId, date: date));

  Future<void> changeDate(int userId, DateTime date) async {
    final scheduleListResult = await _getSchedules(userId, date);

    state = switch (scheduleListResult) {
      Success(:final value) => AsyncData(value),
      Failure(:final exception) => AsyncError(exception, StackTrace.current),
    };
  }
}
