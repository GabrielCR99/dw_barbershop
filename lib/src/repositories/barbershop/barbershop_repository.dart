import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';

typedef SaveDto = ({
  String name,
  String email,
  List<String> openingDays,
  List<int> openingHours
});

abstract interface class BarbershopRepository {
  Future<Either<RepositoryException, Nil>> save(SaveDto dto);
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
    UserModel user,
  );
}
