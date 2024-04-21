import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

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
}
