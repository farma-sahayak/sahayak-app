import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/commands/auth_cmd.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:mobile/shared/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthCmd authCmd;

  AuthBloc(this.authCmd) : super(AuthInitialState()) {
    on<AuthInitializeEvent>(_onInitialize);
    on<AuthSendOTPEvent>(_onSendOTP);
    on<AuthVerifyOTPEvent>(_onVerifyOTP);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthRefreshUserEvent>(_onRefreshUser);
    on<AuthStatusCheckEvent>(_onStatusCheck);
  }

  Future<void> _onInitialize(
    AuthInitializeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      // Check if user is already authenticated
      // final prefs = await SharedPreferences.getInstance();

      // Try to get current user info
      try {
        final user = await authCmd.getCurrentUser();

        emit(AuthenticatedState(user: user!));
      } catch (e) {
        // Token might be expired, clear it
        await authCmd.clearAuthToken();
        // await prefs.remove('session_id');
        emit(AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(
        AuthErrorState(
          errorMessage: 'Failed to initialize authentication: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onStatusCheck(
    AuthStatusCheckEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = await authCmd.getCurrentUser();
    if (user != null) {
      emit(AuthenticatedState(user: user));
    } else {
      emit(AuthUnauthenticatedState());
    }

    // optionally listen to firebase status change
  }

  Future<void> _onSendOTP(
    AuthSendOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final user = await authCmd.signInWithPhoneNumber(event.phoneNumber);
      if (user != null) {
        emit(
          AuthOtpSentState(
            phoneNumber: event.phoneNumber,
            message: 'OTP sent successfully to ${event.phoneNumber}',
          ),
        );
      } else {
        emit(AuthErrorState(errorMessage: "Failed to send OTP, try again"));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: 'Failed to send OTP: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOTP(
    AuthVerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final user = await authCmd.verifyOTP(event.otpCode);

      // Save session info
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('session_id', authResponse.sessionId);
      // await prefs.setString('phone_number', event.phoneNumber);

      emit(AuthenticatedState(user: user!));
    } catch (e) {
      emit(
        AuthErrorState(errorMessage: 'Failed to verify OTP: ${e.toString()}'),
      );
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      // Clear all stored auth data
      // await _apiService.clearAuthToken();
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.remove('session_id');
      // await prefs.remove('phone_number');

      emit(AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(errorMessage: 'Failed to logout: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshUser(
    AuthRefreshUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthenticatedState) {
      try {
        final user = await authCmd.getCurrentUser();

        emit(AuthenticatedState(user: user!));
      } catch (e) {
        if (await authCmd.isAuthError(e as Exception)) {
          // Token expired, logout
          add(AuthLogoutEvent());
        } else {
          emit(
            AuthErrorState(
              errorMessage: 'Failed to refresh user: ${e.toString()}',
            ),
          );
        }
      }
    }
  }

  // Helper methods
  bool get isAuthenticated => state is AuthenticatedState;

  User? get currentUser =>
      state is AuthenticatedState ? (state as AuthenticatedState).user : null;
}
