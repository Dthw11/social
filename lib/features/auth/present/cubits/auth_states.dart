import 'package:social_app/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

class AuthInitinal extends AuthState {}


class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}