import 'package:flutter/material.dart';

enum LoginStateStatus {
  initial,
  error,
  admLogin,
  employeeLogin;
}

final class LoginState {
  final LoginStateStatus status;
  final String? errorMessage;

  const LoginState({required this.status, this.errorMessage});

  const LoginState.initial() : this(status: LoginStateStatus.initial);

  LoginState copyWith({
    LoginStateStatus? status,
    ValueGetter<String?>? errorMessage,
  }) =>
      LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      );
}
