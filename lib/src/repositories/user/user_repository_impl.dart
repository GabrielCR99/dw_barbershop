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
      final Response(:data) = await restClient.unAuth
          .post('/auth', data: {'email': email, 'password': password});

      return Success(data['access_token'] as String);
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
      final Response(:data) = await restClient.auth.get('/me');

      return Success(UserModel.fromMap(data as Map<String, dynamic>));
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
}
