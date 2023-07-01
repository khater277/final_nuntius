import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

abstract class FirebaseHelper {
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
  Future<void> sendMessage(
      {required String phoneNumber, required MessageModel messageModel});

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber});
}

class FirebaseHelperImpl implements FirebaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  @override
  Future<void> sendMessage({
    required String phoneNumber,
    required MessageModel messageModel,
  }) async {
    final String id = const Uuid().v4();
    LastMessageModel lastMessageModel = LastMessageModel(
      senderID: messageModel.senderId,
      receiverID: messageModel.receiverId,
      message: messageModel.message,
      date: messageModel.date,
      media: messageModel.media,
      isImage: messageModel.isImage,
      isVideo: messageModel.isVideo,
      isDoc: messageModel.isDoc,
      isDeleted: messageModel.isDeleted,
      isRead: false,
    );

    /// add message to my database
    await _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .collection(Collections.chats)
        .doc(phoneNumber)
        .set(lastMessageModel.copyWith(isRead: true).toJson());

    await _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .collection(Collections.chats)
        .doc(phoneNumber)
        .collection(Collections.messages)
        .doc(id)
        .set(messageModel.toJson());

    /// add message to friend database

    await _db
        .collection(Collections.users)
        .doc(phoneNumber)
        .collection(Collections.chats)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .set(lastMessageModel.toJson());
    await _db
        .collection(Collections.users)
        .doc(phoneNumber)
        .collection(Collections.chats)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .collection(Collections.messages)
        .doc(id)
        .set(messageModel.toJson());
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber}) {
    return _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .collection(Collections.chats)
        .doc(phoneNumber)
        .collection(Collections.messages)
        .orderBy('date')
        .snapshots();
  }
}
