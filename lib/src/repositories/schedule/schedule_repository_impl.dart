import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../core/rest_client/rest_client.dart';
import './schedule_repository.dart';

final class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;

  const ScheduleRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, Nil>> scheduleClient(
    ({
      int barberShopId,
      int userId,
      String clientName,
      int time,
      DateTime date,
    }) scheduleData,
  ) async {
    try {
      await restClient.auth.post<void>(
        '/schedules',
        data: {
          'barbershop_id': scheduleData.barberShopId,
          'client_name': scheduleData.clientName,
          'date': scheduleData.date.toIso8601String(),
          'user_id': scheduleData.userId,
          'time': scheduleData.time,
        },
      );

      return const Success(Nil());
    } on DioException catch (e, s) {
      const errorMessage = 'Error scheduling client';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }
}
