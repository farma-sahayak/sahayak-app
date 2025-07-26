import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/commands/auth_cmd.dart';
import 'package:mobile/domain/models/auth_request.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthCmd authCmd;
  String _phoneNumber = '';

  AuthBloc(this.authCmd) : super(AuthInitialState()) {
    on<AuthInitializeEvent>(_onInitialize);
    on<AuthSendOTPEvent>(_onSendOTP);
    on<AuthVerifyOTPEvent>(_onVerifyOTP);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthStatusCheckEvent>(_onStatusCheck);
  }

  Future<void> _onInitialize(
    AuthInitializeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      // Check if user is already authenticated
      // Try to get current user info
      try {
        final result = await authCmd
            .isAuthenticated(); // calls to validate token
        if (result.isSuccess) {
          emit(AuthenticatedState());
        } else {
          emit(AuthUnauthenticatedState());
        }
      } catch (e) {
        // Token might be expired, clear it
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
    final result = await authCmd.isAuthenticated();
    if (result.isSuccess) {
      emit(AuthenticatedState());
    } else {
      emit(AuthUnauthenticatedState());
    }

    // optionally listen to firebase status change
  }

  Future<void> _onSendOTP(
    AuthSendOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    _phoneNumber = event.phoneNumber;
    emit(AuthOtpSentState(_phoneNumber));
  }

  Future<void> _onVerifyOTP(
    AuthVerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final authRequest = AuthRequest(
        phoneNumber: _phoneNumber,
        mpin: event.otpCode,
      );
      final result = await authCmd.signup(authRequest);
      if (result.isFailure) {
        emit(AuthErrorState(errorMessage: result.error!.message));
        return;
      }
      emit(AuthenticatedState());
    } catch (e) {
      emit(
        AuthErrorState(errorMessage: 'Failed to verify OTP: ${e.toString()}'),
      );
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await authCmd.logout();
      if (result.isFailure) {
        emit(AuthErrorState(errorMessage: result.error!.message));
        return;
      }
      _phoneNumber = ''; // Clear phone number on logout
      emit(AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(errorMessage: 'Failed to logout: ${e.toString()}'));
    }
  }

  // Helper methods
  bool get isAuthenticated => state is AuthenticatedState;
}
