import '../../../models/user_model.dart';

enum HomeAdmStatus {
  loaded,
  error;
}

final class HomeAdmState {
  final HomeAdmStatus status;
  final List<UserModel> employees;

  const HomeAdmState({
    required this.employees,
    required this.status,
  });

  HomeAdmState copyWith({
    required HomeAdmStatus status,
    List<UserModel>? employees,
  }) =>
      HomeAdmState(employees: employees ?? this.employees, status: status);
}
