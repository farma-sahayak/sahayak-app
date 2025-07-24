import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithPhone(String phoneNumber);
  Future<User?> verifyOTP(String otpCode);
  Future<void> signout();
  Stream<User?> get onAuthStateChanged;
  Future<User?> getCurrentUser();
  Future<void> clearAuthToken();

  bool isAuthError(Exception e);
}
