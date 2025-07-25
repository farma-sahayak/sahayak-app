import 'dart:async';
import 'package:mobile/data/source/base/auth_datasource.dart';
import 'package:mobile/shared/models/user_model.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  String? _verificationId;

  @override
  Future<void> clearAuthToken() async {
    return;
  }

  @override
  Future<User?> getCurrentUser() async {
    return User(
      userId: "userId",
      phoneNumber: "phoneNumber",
      profileCompleted: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Stream<User?> get onAuthStateChanged => Stream<User?>.value(
    User(
      userId: "userId",
      phoneNumber: "phoneNumber",
      profileCompleted: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  Future<User?> signInWithPhone(String phoneNumber) async {
    // final completer = Completer<User?>();

    // await _firebaseAuth.verifyPhoneNumber(
    //   phoneNumber: phoneNumber,
    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     try {
    //       final userCredential = await _firebaseAuth.signInWithCredential(
    //         credential,
    //       );
    //       completer.complete(userCredential.user);
    //     } catch (e) {
    //       completer.completeError(e);
    //     }
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     completer.completeError(e);
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     _verificationId = verificationId;
    //     completer.complete(null); // code sent, wait for manual OTP input
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     _verificationId = verificationId;
    //   },
    // );

    // return completer.future;
    return User(
      userId: "userId",
      phoneNumber: phoneNumber,
      profileCompleted: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<User?> verifyOTP(String otpCode) async {
    if (_verificationId == null) {
      throw Exception(
        "Verification ID not set. Please initiate sign-in first.",
      );
    }

    try {
      // final credential = PhoneAuthProvider.credential(
      //   verificationId: _verificationId!,
      //   smsCode: otpCode,
      // );
      // final userCred = await _firebaseAuth.signInWithCredential(credential);
      // return userCred.user;
      return User(
        userId: "userId",
        phoneNumber: "phoneNumber",
        profileCompleted: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  @override
  Future<void> signout() async => Future.value();
}
