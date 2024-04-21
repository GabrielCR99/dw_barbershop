enum LoginStateStatus {
  initial,
  error,
  admLogin,
  employeeLogin;
}

typedef LoginState = ({LoginStateStatus status, String? errorMessage});
