part of 'auth_cubit.dart';

class AuthState {}

class AuthInitial extends AuthState {}

// Loading

class AuthLoginLoading extends AuthState {}

class AuthSlicLoginLoading extends AuthState {}

// * Success

class AuthLoginSuccess extends AuthState {}

class AuthSlicLoginSuccess extends AuthState {}

// ! Error

class AuthLoginError extends AuthState {
  final String message;

  AuthLoginError(this.message);
}

class AuthSlicLoginError extends AuthState {
  final String message;

  AuthSlicLoginError(this.message);
}
