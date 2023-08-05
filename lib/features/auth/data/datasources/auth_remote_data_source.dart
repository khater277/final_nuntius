import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AuthRemoteDataSource {
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    required Function(FirebaseAuthException error) verificationFailed,
    required Function(String verificationId, int? resendToken) codeSent,
  });

  Future<UserCredential?> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  Future<Either<String, Stream<TaskSnapshot>>?> uploadImageToStorage({
    required String collectionName,
    required File file,
  });
  Future<void> updateUserToken({required String token});

  Future<void> addUserToFirestore({required UserData user});
  Future<UserData?> getUserFromFirestore({required String phoneNumber});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseHelper firebaseHelper;

  AuthRemoteDataSourceImpl({required this.firebaseHelper});
  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    required Function(FirebaseAuthException error) verificationFailed,
    required Function(String verificationId, int? resendToken) codeSent,
  }) {
    return firebaseHelper.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
    );
  }

  @override
  Future<UserCredential?> signInWithPhoneNumber(
      {required String verificationId, required String smsCode}) {
    return firebaseHelper.signInWithPhoneNumber(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  Future<Either<String, Stream<TaskSnapshot>>?> uploadImageToStorage(
      {required String collectionName, required File file}) async {
    return firebaseHelper.uploadImageToStorage(
      collectionName: collectionName,
      file: file,
    );
  }

  @override
  Future<void> addUserToFirestore({required UserData user}) {
    return firebaseHelper.addUserToFirestore(user: user);
  }

  @override
  Future<UserData?> getUserFromFirestore({required String phoneNumber}) {
    return firebaseHelper.getUserFromFirestore(phoneNumber: phoneNumber);
  }

  @override
  Future<void> updateUserToken({required String token}) {
    return firebaseHelper.updateUserToken(token: token);
  }
}
