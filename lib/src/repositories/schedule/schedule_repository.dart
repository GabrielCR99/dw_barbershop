import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../models/schedule_model.dart';

abstract interface class ScheduleRepository {
  Future<Either<RepositoryException, Nil>> scheduleClient(
    ({
      int barberShopId,
      int userId,
      int time,
      String clientName,
      DateTime date,
    }) scheduleData,
  );

  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
    ({int userId, DateTime date}) filter,
  );
}
