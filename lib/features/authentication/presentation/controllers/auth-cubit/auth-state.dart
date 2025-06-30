abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

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

class AuthChange extends AuthState {}

class AuthRebuild extends AuthState {}
