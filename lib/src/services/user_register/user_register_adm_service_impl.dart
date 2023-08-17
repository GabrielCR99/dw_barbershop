import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../repositories/user/user_repository.dart';
import '../user_login/user_login_service.dart';
import 'user_register_adm_service.dart';

class UserRegisterAdmServiceImpl implements UserRegisterAdmService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  const UserRegisterAdmServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });
  @override
  Future<Either<ServiceException, Nil>> execute(UserDto userDto) async {
    final registerResult = await userRepository.registerAdmin(userDto);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(
          email: userDto.email,
          password: userDto.password,
        );

      case Failure(:final exception):
        return Failure(ServiceException(message: exception.message));
    }
  }
}
