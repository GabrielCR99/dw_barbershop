enum BarbershopRegisterStateStatus {
  initial,
  success,
  error;
}

final class BarbershopRegisterState {
  final BarbershopRegisterStateStatus status;
  final List<String> openingDays;
  final List<int> openingHours;

  const BarbershopRegisterState({
    required this.status,
    required this.openingDays,
    required this.openingHours,
  });

  BarbershopRegisterState.initial()
      : status = BarbershopRegisterStateStatus.initial,
        openingDays = [],
        openingHours = [];

  BarbershopRegisterState copyWith({
    BarbershopRegisterStateStatus? status,
    List<String>? openingDays,
    List<int>? openingHours,
  }) =>
      BarbershopRegisterState(
        status: status ?? this.status,
        openingDays: openingDays ?? this.openingDays,
        openingHours: openingHours ?? this.openingHours,
      );
}
