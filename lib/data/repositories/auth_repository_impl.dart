import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/data/source/remote/firebase_auth_datasource.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuthDatasource firebaseAuthDatasource;

  AuthRepositoryImpl(this.firebaseAuthDatasource);

  @override
  Future<void> clearAuthToken() async {
    return firebaseAuthDatasource.clearAuthToken();
  }

  @override
  Future<User?> getCurrentUser() async {
    return firebaseAuthDatasource.getCurrentUser();
  }

  @override
  bool isAuthError(Exception e) {
    return e.toString().contains('Unauthorized') ||
        e.toString().contains('401');
  }

  @override
  Stream<User?> get onAuthStateChanged =>
      firebaseAuthDatasource.onAuthStateChanged;

  @override
  Future<User?> signInWithPhone(String phoneNumber) async {
    return firebaseAuthDatasource.signInWithPhone(phoneNumber);
  }

  @override
  Future<void> signout() async {
    return firebaseAuthDatasource.signout();
  }

  @override
  Future<User?> verifyOTP(String otpCode) async {
    return firebaseAuthDatasource.verifyOTP(otpCode);
  }
}
