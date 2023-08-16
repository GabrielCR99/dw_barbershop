import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';
import '../../repositories/barbershop/barbershop_repository.dart';
import '../../repositories/barbershop/barbershop_repository_impl.dart';
import '../../repositories/user/user_repository.dart';
import '../../repositories/user/user_repository_impl.dart';
import '../../services/user_login/user_login_service.dart';
import '../../services/user_login/user_login_service_impl.dart';
import '../fp/either.dart';
import '../rest_client/rest_client.dart';

part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
RestClient restClient(RestClientRef _) => RestClient();

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepositoryImpl(restClient: ref.read(restClientProvider));

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(userRepository: ref.read(userRepositoryProvider));

@Riverpod(keepAlive: true)
FutureOr<UserModel> getMe(GetMeRef ref) async {
  final result = await ref.watch(userRepositoryProvider).me();

  return switch (result) {
    Success(:final value) => value,
    Failure(:final exception) => throw exception,
  };
}

@Riverpod(keepAlive: true)
BarbershopRepository barberShopRepository(BarberShopRepositoryRef ref) =>
    BarbershopRepositoryImpl(restClient: ref.read(restClientProvider));

@Riverpod(keepAlive: true)
FutureOr<BarbershopModel> getMyBarbershop(GetMyBarbershopRef ref) async {
  final userModel = await ref.watch(getMeProvider.future);
  final barberShopRepository = ref.watch(barberShopRepositoryProvider);
  final result = await barberShopRepository.getMyBarbershop(userModel);

  return switch (result) {
    Success(:final value) => value,
    Failure(:final exception) => throw exception,
  };
}
