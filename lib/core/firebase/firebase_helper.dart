import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseHelper {
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<UserCredential?> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  });
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    required Function(FirebaseAuthException error) verificationFailed,
    required Function(String verificationId, int? resendToken) codeSent,
  });
  Future<void> addUserToFirestore({required UserData user});
  Future<UserData?> getUserFromFirestore({required String phoneNumber});
  Future<List<UserData>?> getAllUsersFromFirestore();
  Future<Stream<TaskSnapshot>> uploadImageToStorage({
    required String collectionName,
    required File image,
  });
}

class FirebaseHelperImpl implements FirebaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    UserCredential? userCredential;

    try {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    } catch (error) {
      return userCredential;
    }
  }

  @override
  Future<UserCredential?> signInWithFacebook() async {
    UserCredential? userCredential;

    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return _auth.signInWithCredential(facebookAuthCredential);
    } catch (error) {
      return userCredential;
    }
  }

  @override
  Future<UserCredential?> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    UserCredential? userCredential;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      return userCredential;
    }
  }

  @override
  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required Function(PhoneAuthCredential credential) verificationCompleted,
      required Function(FirebaseAuthException error) verificationFailed,
      required Function(String verificationId, int? resendToken) codeSent}) {
    return _auth.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<void> addUserToFirestore({required UserData user}) {
    return _db.collection(Collections.users).doc(user.phone).set(user.toJson());
  }

  @override
  Future<UserData?> getUserFromFirestore({required String phoneNumber}) async {
    UserData? user;
    try {
      final result =
          await _db.collection(Collections.users).doc(phoneNumber).get();
      user = UserData.fromJson(result.data()!);
      return user;
    } catch (error) {
      return user;
    }
  }

  @override
  Future<Stream<TaskSnapshot>> uploadImageToStorage(
      {required String collectionName, required File image}) async {
    return _storage
        .ref("$collectionName/${Uri.file(image.path).pathSegments.last}")
        .putFile(image)
        .snapshotEvents;
  }

  @override
  Future<List<UserData>?> getAllUsersFromFirestore() async {
    List<UserData>? users;
    try {
      final response = await _db.collection(Collections.users).get();
      final docs = response.docs;
      if (docs.isEmpty) {
        users = [];
      } else {
        users = [];
        for (var element in docs) {
          users.add(UserData.fromJson(element.data()));
        }
      }
      return users;
    } catch (error) {
      return users;
    }
  }
}
