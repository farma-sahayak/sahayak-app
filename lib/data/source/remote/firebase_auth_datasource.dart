import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/data/source/base/auth_datasource.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _verificationId;

  @override
  Future<void> clearAuthToken() async {
    await _firebaseAuth.signOut(); // signing out clears any cached token
  }

  @override
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInWithPhone(String phoneNumber) async {
    final completer = Completer<User?>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final userCredential = await _firebaseAuth.signInWithCredential(
            credential,
          );
          completer.complete(userCredential.user);
        } catch (e) {
          completer.completeError(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        completer.complete(null); // code sent, wait for manual OTP input
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<User?> verifyOTP(String otpCode) async {
    if (_verificationId == null) {
      throw Exception(
        "Verification ID not set. Please initiate sign-in first.",
      );
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      return userCred.user;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  @override
  Future<void> signout() async => _firebaseAuth.signOut();
}
