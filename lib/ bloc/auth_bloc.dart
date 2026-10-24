
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await authService.signUp(
          event.email,
          event.password,
        );

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(_errorMessage(e)));
      }
    });
  }

  String _errorMessage(Object error) {
    if (error.toString().contains('email-already-in-use')) {
      return 'This email is already registered.';
    }

    if (error.toString().contains('invalid-email')) {
      return 'Please enter a valid email.';
    }

    if (error.toString().contains('weak-password')) {
      return 'Password must be stronger.';
    }

    if (error.toString().contains('network-request-failed')) {
      return 'Check your internet connection.';
    }

    return 'Registration failed. Please try again.';
  }
}
