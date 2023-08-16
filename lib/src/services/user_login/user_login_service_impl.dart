import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/local_storage_keys.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../repositories/user/user_repository.dart';
import 'user_login_service.dart';

final class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;

  const UserLoginServiceImpl({required this.userRepository});

  @override
  Future<Either<ServiceException, Nil>> execute({
    required String email,
    required String password,
  }) async {
    final result = await userRepository.login(email: email, password: password);

    switch (result) {
      case Success(:final value):
        final sp = await SharedPreferences.getInstance();
        await sp.setString(LocalStorageKeys.accessToken, value);

        return const Success(Nil());
      case Failure(:final exception):
        return switch (exception) {
          AuthError() =>
            const Failure(ServiceException(message: 'Erro ao realizar login')),
          UnauthorizedException() => const Failure(
              ServiceException(message: 'Login ou senha inválidos'),
            ),
        };
    }
  }
}
