import 'package:equatable/equatable.dart';
import 'package:mobile/shared/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AuthOtpSentState extends AuthState {
  final String phoneNumber;
  final String message;

  const AuthOtpSentState({required this.phoneNumber, required this.message});

  @override
  List<Object?> get props => [phoneNumber, message];
}

class AuthenticatedState extends AuthState {
  final User user;
  final String token;
  final String sessionId;
  final bool isNewUser;

  const AuthenticatedState({
    required this.user,
    required this.token,
    required this.sessionId,
    required this.isNewUser,
  });

  @override
  List<Object?> get props => [user, token, sessionId, isNewUser];
}
