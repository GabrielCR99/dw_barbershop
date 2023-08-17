import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../repositories/user/user_repository.dart';

abstract interface class UserRegisterAdmService {
  Future<Either<ServiceException, Nil>> execute(UserDto userDto);
}
