import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
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

      if (e.response != null) {
        final Response(:statusCode) = e.response!;

        if (statusCode == HttpStatus.forbidden) {
          log('Invalid credentials', error: e, stackTrace: s);

          return const Failure(UnauthorizedException());
        }
      }
      log(errorMessage, error: e, stackTrace: s);

      return const Failure(AuthError(message: errorMessage));
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
}
