part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthCheckRequested extends AuthEvent {}

final class AuthSignedIn extends AuthEvent {
  final User user;

  const AuthSignedIn(this.user);
}

final class AuthSignedOut extends AuthEvent {}

final class AuthGoogleSignInRequested extends AuthEvent {}
