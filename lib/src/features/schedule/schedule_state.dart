import 'package:flutter/material.dart';

enum ScheduleStateStatus {
  initial,
  success,
  error;
}

final class ScheduleState {
  final ScheduleStateStatus status;
  final int? scheduleHour;
  final DateTime? scheduleDate;

  const ScheduleState({
    required this.status,
    this.scheduleHour,
    this.scheduleDate,
  });

  ScheduleState.initial()
      : status = ScheduleStateStatus.initial,
        scheduleHour = null,
        scheduleDate = null;

  ScheduleState copyWith({
    ScheduleStateStatus? status,
    ValueGetter<int?>? scheduleHour,
    ValueGetter<DateTime?>? scheduleDate,
  }) =>
      ScheduleState(
        status: status ?? this.status,
        scheduleHour: scheduleHour != null ? scheduleHour() : this.scheduleHour,
        scheduleDate: scheduleDate != null ? scheduleDate() : this.scheduleDate,
      );
}
