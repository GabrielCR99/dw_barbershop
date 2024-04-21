enum EmployeeRegisterStatus {
  initial,
  success,
  error;
}

final class EmployeeRegisterState {
  final EmployeeRegisterStatus status;
  final bool registerAdm;
  final List<String> workdays;
  final List<int> workHours;

  const EmployeeRegisterState({
    required this.status,
    required this.registerAdm,
    required this.workdays,
    required this.workHours,
  });

  EmployeeRegisterState.initial()
      : this(
          status: EmployeeRegisterStatus.initial,
          registerAdm: false,
          workdays: [],
          workHours: [],
        );

  EmployeeRegisterState copyWith({
    EmployeeRegisterStatus? status,
    bool? registerAdm,
    List<String>? workdays,
    List<int>? workHours,
  }) =>
      EmployeeRegisterState(
        status: status ?? this.status,
        registerAdm: registerAdm ?? this.registerAdm,
        workdays: workdays ?? this.workdays,
        workHours: workHours ?? this.workHours,
      );
}
