import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, void>> verifyPhoneNumber(
      {required String phoneNumber,
      required Function(PhoneAuthCredential credential) verificationCompleted,
      required Function(FirebaseAuthException error) verificationFailed,
      required Function(String verificationId, int? resendToken)
          codeSent}) async {
    try {
      final response = await authRemoteDataSource.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
      );
      return Right(response);
    } on FirebaseAuthException catch (error) {
      return Left(ServerFailure(
        error: error,
        type: NetworkErrorTypes.auth,
      ));
    }
  }

  @override
  Future<Either<Failure, UserCredential?>> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final response = await authRemoteDataSource.signInWithPhoneNumber(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      if (response != null) {
        SharedPrefHelper.setUid(uId: response.user!.uid);
        // authRemoteDataSource.getUserFromFirestore(uid: response.user!.uid);
        final result = await getUserFromFirestore(uid: response.user!.uid);
        result.fold(
          (failure) {
            HiveHelper.setCurrentUser(user: null);
            return Right(response);
          },
          (user) {
            HiveHelper.setCurrentUser(user: user);
            return Right(response);
          },
        );
        return Right(response);
      } else {
        FirebaseAuthException exception =
            FirebaseAuthException(code: 'request-cancelled');
        return Left(ServerFailure(
          error: exception,
          type: NetworkErrorTypes.auth,
        ));
      }
    } on FirebaseAuthException catch (error) {
      return Left(ServerFailure(
        error: error,
        type: NetworkErrorTypes.auth,
      ));
    }
  }

  @override
  Either<Failure, Stream<TaskSnapshot>?> uploadImageToStorage(
      {required String collectionName, required File image}) {
    try {
      final response = authRemoteDataSource.uploadImageToStorage(
        collectionName: collectionName,
        image: image,
      );
      return Right(response);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error: error, type: NetworkErrorTypes.storage));
    }
  }

  @override
  Future<Either<Failure, void>> addUserToFirestore(
      {required UserData user}) async {
    try {
      final response =
          await authRemoteDataSource.addUserToFirestore(user: user);
      return Right(response);
    } on FirebaseException catch (error) {
      return Left(
          ServerFailure(error: error, type: NetworkErrorTypes.firestore));
    }
  }

  @override
  Future<Either<Failure, UserData>> getUserFromFirestore(
      {required String uid}) async {
    try {
      final response =
          await authRemoteDataSource.getUserFromFirestore(uid: uid);
      if (response != null) {
        return Right(response);
      } else {
        FirebaseAuthException exception =
            FirebaseAuthException(code: 'not-found');
        return Left(
            ServerFailure(error: exception, type: NetworkErrorTypes.firestore));
      }
    } on FirebaseException catch (error) {
      return Left(
          ServerFailure(error: error, type: NetworkErrorTypes.firestore));
    }
  }
}
