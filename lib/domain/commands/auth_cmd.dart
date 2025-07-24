import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';

class AuthCmd {
  final AuthRepository authReppository;

  const AuthCmd(this.authReppository);

  Future<User?> getCurrentUser() async {
    return authReppository.getCurrentUser();
  }

  Future<void> clearAuthToken() async {
    return authReppository.clearAuthToken();
  }

  Future<User?> signInWithPhoneNumber(String phoneNumber) async {
    return authReppository.signInWithPhone(phoneNumber);
  }

  Future<User?> verifyOTP(String otpCode) async {
    return authReppository.verifyOTP(otpCode);
  }

  Future<bool> isAuthError(Exception e) async {
    return authReppository.isAuthError(e);
  }
}
