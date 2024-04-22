import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../core/rest_client/rest_client.dart';
import '../../models/schedule_model.dart';
import 'schedule_repository.dart';

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

  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
    ({int userId, DateTime date}) filter,
  ) async {
    try {
      final Response(:data as List<Object?>) = await restClient.auth.get(
        '/schedules',
        queryParameters: {
          'user_id': filter.userId,
          'date': filter.date.toIso8601String(),
        },
      );

      return Success(
        data.cast<Map<String, dynamic>>().map(ScheduleModel.fromJson).toList(),
      );
    } on DioException catch (e) {
      const errorMessage = 'Error finding schedule by date';
      log(errorMessage, error: e);

      return const Failure(RepositoryException(message: errorMessage));
    } on FormatException catch (e) {
      const errorMessage = 'Error parsing schedule data';
      log(errorMessage, error: e);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }
}
