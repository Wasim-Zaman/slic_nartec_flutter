part of 'auth_cubit.dart';

class AuthState {}

class AuthInitial extends AuthState {}

// Loading

class AuthLoginLoading extends AuthState {}

// * Success

class AuthLoginSuccess extends AuthState {}

// ! Error

class AuthLoginError extends AuthState {
  final String message;

  AuthLoginError(this.message);
}
