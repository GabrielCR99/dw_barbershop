import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../core/rest_client/rest_client.dart';
import '../../models/user_model.dart';
import 'user_repository.dart';

final class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;

  const UserRepositoryImpl({required this.restClient});

  @override
  Future<Either<AuthException, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response(data: {'access_token': String accessToken}!) =
          await restClient.unAuth.post<Map<String, dynamic>>(
        '/auth',
        data: {'email': email, 'password': password},
      );

      return Success(accessToken);
    } on DioException catch (e, s) {
      const errorMessage = 'Error while login';
      log(errorMessage, error: e, stackTrace: s);

      return switch (e.response?.statusCode) {
        HttpStatus.forbidden => const Failure(UnauthorizedException()),
        _ => Failure(AuthError(message: e.message ?? errorMessage)),
      };
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) =
          await restClient.auth.get<Map<String, dynamic>>('/me');

      return Success(UserModel.fromMap(data!));
    } on DioException catch (e, s) {
      const errorMessage = 'Error while fetching user data';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    } on FormatException catch (e, s) {
      const errorMessage = 'Error while parsing user data';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
    UserDto userDto,
  ) async {
    try {
      await restClient.unAuth.post<void>(
        '/users',
        data: {
          'name': userDto.name,
          'email': userDto.email,
          'password': userDto.password,
          'profile': 'ADM',
        },
      );

      return const Success(Nil());
    } on DioException catch (e, s) {
      const errorMessage = 'Error while registering admin user';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
    int barbershopId,
  ) async {
    try {
      final Response(:data) = await restClient.auth.get<List<Object?>>(
        '/users',
        queryParameters: {'barbershop_id': barbershopId},
      );

      final employees = (data! as List)
          .cast<Map<String, dynamic>>()
          .map(UserModel.fromMap)
          .toList();

      return Success(employees);
    } on DioException catch (e) {
      log('Error while fetching employees', error: e);

      return const Failure(
        RepositoryException(message: 'Error while fetching employees'),
      );
    } on FormatException catch (e) {
      log('Error while parsing employees', error: e);

      return const Failure(
        RepositoryException(message: 'Error while parsing employees'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
    ({List<int> workHours, List<String> workdays}) userModel,
  ) async {
    try {
      final userModelResult = await me();

      final int userId;

      switch (userModelResult) {
        case Success(value: UserModel(:final id)):
          userId = id;
        case Failure(:final exception):
          return Failure(exception);
      }

      await restClient.auth.put<void>(
        '/users/$userId',
        data: {
          'work_days': userModel.workdays,
          'work_hours': userModel.workHours,
        },
      );

      return const Success(Nil());
    } on DioException catch (e, s) {
      const errorMessage = 'Error while registering admin as employee';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
    ({
      int barberShopId,
      String email,
      String name,
      String password,
      List<int> workHours,
      List<String> workdays
    }) userModel,
  ) async {
    try {
      await restClient.auth.post<void>(
        '/users/',
        data: {
          'name': userModel.name,
          'email': userModel.email,
          'password': userModel.password,
          'profile': 'EMPLOYEE', // 'ADM' or 'EMPLOYEE
          'barbershop_id': userModel.barberShopId,
          'work_days': userModel.workdays,
          'work_hours': userModel.workHours,
        },
      );

      return const Success(Nil());
    } on DioException catch (e, s) {
      const errorMessage = 'Error while registering employee';
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(RepositoryException(message: errorMessage));
    }
  }
}
