import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/stories/data/models/contact_story_model/contact_story_model.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
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
  Future<Either<String, Stream<TaskSnapshot>>> uploadImageToStorage({
    required String collectionName,
    required File file,
  });
  Future<void> updateUserToken({required String token});
  Future<void> sendMessage(
      {required String phoneNumber,
      required LastMessageModel lastMessageModel,
      required MessageModel messageModel});

  Future<void> setLastStory({required StoryModel storyModel});
  Future<void> sendStory({required StoryModel storyModel});

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber});

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats();

  Stream<QuerySnapshot<Map<String, dynamic>>> getStories();

  Future<void> deleteStory({required String storyId});

  Stream<QuerySnapshot<Map<String, dynamic>>> getContactsLastStories();
  Future<List<ContactStoryModel>?> getContactsCurrentStories(
      {required List<UserData> users});

  Future<void> updateLastStory({required StoryModel storyModel});
  Future<void> deleteLastStory();
  Future<void> updateStory(
      {required StoryModel storyModel, required String phoneNumber});

  Future<void> deleteMessage({
    required String messageId,
    required String userPhone,
  });

  Future<void> deleteLastMessage({required String userPhone});
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
  Future<Either<String, Stream<TaskSnapshot>>> uploadImageToStorage(
      {required String collectionName, required File file}) async {
    final reference = _storage
        .ref("$collectionName/${Uri.file(file.path).pathSegments.last}");

    try {
      final result = await reference.getDownloadURL();
      return Left(result);
    } on FirebaseException {
      final result = _storage
          .ref("$collectionName/${Uri.file(file.path).pathSegments.last}")
          .putFile(file)
          .snapshotEvents;
      return Right(result);
    }
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
    required LastMessageModel lastMessageModel,
    required MessageModel messageModel,
  }) async {
    final String id = const Uuid().v4();

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
        .set(messageModel.copyWith(messageId: id).toJson());

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
        .set(messageModel.copyWith(messageId: id).toJson());
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

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    return _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .collection(Collections.chats)
        .orderBy('date', descending: true)
        .snapshots();
  }

  @override
  Future<void> updateUserToken({required String token}) {
    return _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone!)
        .update({'token': token});
  }

  @override
  Future<void> setLastStory({required StoryModel storyModel}) async {
    _db
        .collection(Collections.stories)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .set(storyModel.toJson());
  }

  @override
  Future<void> sendStory({required StoryModel storyModel}) async {
    _db
        .collection(Collections.stories)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .collection(Collections.currentStories)
        .doc(storyModel.id)
        .set(storyModel.toJson());
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getStories() {
    return _db
        .collection(Collections.stories)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .collection(Collections.currentStories)
        .orderBy('date')
        .snapshots();
  }

  @override
  Future<void> deleteStory({required String storyId}) async {
    _db
        .collection(Collections.stories)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .collection(Collections.currentStories)
        .doc(storyId)
        .delete();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getContactsLastStories() {
    return _db
        .collection(Collections.stories)
        .orderBy('date', descending: true)
        .snapshots();
  }

  @override
  Future<List<ContactStoryModel>?> getContactsCurrentStories(
      {required List<UserData> users}) async {
    try {
      List<ContactStoryModel> contactsStories = [];
      for (int i = 0; i < users.length; i++) {
        List<StoryModel> stories = [];
        final response = await _db
            .collection(Collections.stories)
            .doc(users[i].phone)
            .collection(Collections.currentStories)
            .orderBy('date')
            .get();

        final docs = response.docs;
        if (docs.isNotEmpty) {
          for (var element in docs) {
            final storyModel = StoryModel.fromJson(element.data());
            // print("=============>${storyModel.toString()}");
            if (storyModel.canView!
                .contains(HiveHelper.getCurrentUser()!.phone)) {
              stories.add(storyModel);
              // print(
              //     "canView====>${storyModel.canView} ----- myPhone====>${HiveHelper.getCurrentUser()!.phone}");
            }
          }
        }
        final contactStoryModel = ContactStoryModel(
          user: users[i],
          stories: stories,
        );
        if (contactStoryModel.stories != null &&
            contactStoryModel.stories!.isNotEmpty) {
          contactsStories.add(
            ContactStoryModel(
              user: users[i],
              stories: stories,
            ),
          );
        }
      }
      return contactsStories;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> updateLastStory({required StoryModel storyModel}) async {
    _db
        .collection(Collections.stories)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .update(storyModel.toJson());
  }

  @override
  Future<void> deleteLastStory() async {
    _db
        .collection(Collections.stories)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .delete();
  }

  @override
  Future<void> updateStory(
      {required StoryModel storyModel, required String phoneNumber}) async {
    _db
        .collection(Collections.stories)
        .doc(phoneNumber)
        .collection(Collections.currentStories)
        .doc(storyModel.id)
        .update(storyModel.toJson());
  }

  @override
  Future<void> deleteMessage({
    required String messageId,
    required String userPhone,
  }) async {
    await _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .collection(Collections.chats)
        .doc(userPhone)
        .collection(Collections.messages)
        .doc(messageId)
        .update({"isDeleted": true});

    await _db
        .collection(Collections.users)
        .doc(userPhone)
        .collection(Collections.chats)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .collection(Collections.messages)
        .doc(messageId)
        .update({"isDeleted": true});
  }

  @override
  Future<void> deleteLastMessage({
    required String userPhone,
  }) async {
    await _db
        .collection(Collections.users)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .collection(Collections.chats)
        .doc(userPhone)
        .update({"isDeleted": true});

    await _db
        .collection(Collections.users)
        .doc(userPhone)
        .collection(Collections.chats)
        .doc(HiveHelper.getCurrentUser()!.phone)
        .update({"isDeleted": true});
  }
}
