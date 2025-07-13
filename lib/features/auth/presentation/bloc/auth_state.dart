

import 'package:fairshare/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthAwaitingOTP extends AuthState {
  final User user;

  AuthAwaitingOTP(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}