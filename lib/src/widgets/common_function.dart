// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommonFunction {
  Future<String> loginWithPhone({required String phoneNumber}) async {
    Completer<String> verificationIdCompleter = Completer();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => debugPrint("You are logged in successfully"));
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationIdCompleter.completeError(e);
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        debugPrint("verificationId : $verificationId");
        verificationIdCompleter.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return verificationIdCompleter.future;
  }

  Future<bool> verifyOtp(
      {required String smsCode, required String verificationID}) async {
    bool isVerified = false;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);
    await FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((value) => isVerified = true)
        .catchError((e) => isVerified = false);
    return isVerified;
  }
}
