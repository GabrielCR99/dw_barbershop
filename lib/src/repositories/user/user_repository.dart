import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../models/user_model.dart';

typedef UserDto = ({String name, String email, String password});

abstract interface class UserRepository {
  Future<Either<AuthException, String>> login({
    required String email,
    required String password,
  });

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(UserDto userDto);

  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
    int barbershopId,
  );

  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
    ({List<String> workdays, List<int> workHours}) userModel,
  );

  Future<Either<RepositoryException, Nil>> registerEmployee(
    ({
      int barberShopId,
      String name,
      String email,
      String password,
      List<String> workdays,
      List<int> workHours,
    }) userModel,
  );
}
