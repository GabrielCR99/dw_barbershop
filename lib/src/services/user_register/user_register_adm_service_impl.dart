import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../repositories/user/user_repository.dart';
import '../user_login/user_login_service.dart';
import 'user_register_adm_service.dart';

final class UserRegisterAdmServiceImpl implements UserRegisterAdmService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  const UserRegisterAdmServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(UserDto userDto) async {
    final registerResult = await userRepository.registerAdmin(userDto);

    return switch (registerResult) {
      Success() => await userLoginService.execute(
          email: userDto.email,
          password: userDto.password,
        ),
      Failure(:final exception) =>
        Failure(ServiceException(message: exception.message)),
    };
  }
}
