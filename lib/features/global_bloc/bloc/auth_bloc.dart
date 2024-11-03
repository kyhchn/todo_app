import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/core/resources/data_state.dart';
import 'package:todo_app/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignedIn>(_onAuthSignedIn);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthSignedOut>(
      (event, emit) => signOut(),
    );
  }

  final AuthRepository _authRepository;

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = _authRepository.user;
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthSignedIn(
    AuthSignedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthSuccess(event.user));
  }

  void _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithGoogle();

    if (result is DataSuccess<User>) {
      emit(AuthSuccess(result.data!));
    } else {
      emit(AuthError(result.message!));
    }
  }

  void signOut() async {
    await _authRepository.signOut();
    add(AuthCheckRequested());
  }
}
