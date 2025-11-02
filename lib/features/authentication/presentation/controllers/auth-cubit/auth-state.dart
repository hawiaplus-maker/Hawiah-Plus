abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class validateLoading extends AuthState {}

class validateUnAuthorized extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  AuthSuccess({
    required this.message,
    this.data,
  });
}

class ForgetPasswordSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  ForgetPasswordSuccess({
    required this.message,
    this.data,
  });
}

class VerifyOTPSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  VerifyOTPSuccess({
    required this.message,
    this.data,
  });
}

class ResendCodeSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  ResendCodeSuccess({
    required this.message,
    this.data,
  });
}

class ResetPasswordSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  ResetPasswordSuccess({
    required this.message,
    this.data,
  });
}

class LogOutSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  LogOutSuccess({
    required this.message,
    this.data,
  });
}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  ForgotPasswordSuccess({
    required this.message,
    this.data,
  });
}

class CompleteRegisterSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  CompleteRegisterSuccess({
    required this.message,
    this.data,
  });
}

class RegisterSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  RegisterSuccess({
    required this.message,
    this.data,
  });
}

class ValidateMobileSuccess extends AuthState {
  final String message;

  ValidateMobileSuccess({
    required this.message,
  });
}

class ValidateMobileError extends AuthState {
  final String message;

  ValidateMobileError({
    required this.message,
  });
}

class AuthCodeResentLoading extends AuthState {}

class AuthCodeResentSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;
  AuthCodeResentSuccess({required this.message, this.data});
}

class AuthCodeResentError extends AuthState {
  final String message;
  AuthCodeResentError({required this.message});
}

class AuthTimerState extends AuthState {
  final int remainingTime;
  final bool isTimerCompleted;

  AuthTimerState({required this.remainingTime, required this.isTimerCompleted});
}

class AuthChange extends AuthState {}

class AuthRebuild extends AuthState {}
