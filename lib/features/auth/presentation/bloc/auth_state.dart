import 'package:equatable/equatable.dart';

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

  const AuthOtpSentState(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthenticatedState extends AuthState {
  final bool isNewUser = false;

  const AuthenticatedState();

  @override
  List<Object?> get props => [isNewUser];
}
