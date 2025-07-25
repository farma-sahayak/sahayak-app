import 'package:mobile/shared/models/user_model.dart';

abstract class AuthDatasource {
  Future<User?> signInWithPhone(String phoneNumber);
  Future<User?> verifyOTP(String otpCode);
  Future<void> signout();
  Stream<User?> get onAuthStateChanged;
  Future<User?> getCurrentUser();
  Future<void> clearAuthToken();
}
