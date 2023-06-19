import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    required Function(FirebaseAuthException error) verificationFailed,
    required Function(String verificationId, int? resendToken) codeSent,
  });
  Future<Either<Failure, UserCredential?>> signInWithPhoneNumber(
      {required String verificationId, required String smsCode});

  Future<Either<Failure, Stream<TaskSnapshot>?>> uploadImageToStorage({
    required String collectionName,
    required File image,
  });
  Future<Either<Failure, void>> addUserToFirestore({required UserData user});
  Future<Either<Failure, UserData>> getUserFromFirestore(
      {required String phoneNumber});
}
