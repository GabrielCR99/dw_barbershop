import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../core/rest_client/rest_client.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';
import 'barbershop_repository.dart';

final class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient restClient;

  const BarbershopRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
    UserModel user,
  ) async {
    switch (user) {
      case UserModelAdm():
        final Response(:data) = await restClient.auth.get<List<Object?>>(
          '/barbershop',
          queryParameters: {'user_id': '#userAuthRef'},
        );
        final List(first: response) = data!;

        return Success(
          BarbershopModel.fromMap(response! as Map<String, dynamic>),
        );
      case UserModelEmployee():
        final Response<Map<String, dynamic>>(:data) =
            await restClient.auth.get('/barbershop/${user.barberShopId}');

        return Success(BarbershopModel.fromMap(data!));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> save(SaveDto dto) async {
    try {
      await restClient.auth.post<void>(
        '/barbershop',
        data: {
          'user_id': '#userAuthRef',
          'name': dto.name,
          'email': dto.email,
          'opening_days': dto.openingDays,
          'opening_hours': dto.openingHours,
        },
      );

      return const Success(Nil());
    } on DioException catch (e, s) {
      const errorMessage = 'Erro ao salvar barbearia';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }
}
