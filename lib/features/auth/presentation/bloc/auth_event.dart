import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitializeEvent extends AuthEvent {}

class AuthSendOTPEvent extends AuthEvent {
  final String phoneNumber;

  const AuthSendOTPEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class AuthVerifyOTPEvent extends AuthEvent {
  final String phoneNumber;
  final String otpCode;

  const AuthVerifyOTPEvent(this.phoneNumber, this.otpCode);

  @override
  List<Object> get props => [phoneNumber, otpCode];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthRefreshUserEvent extends AuthEvent {}

class AuthStatusCheckEvent extends AuthEvent {}
