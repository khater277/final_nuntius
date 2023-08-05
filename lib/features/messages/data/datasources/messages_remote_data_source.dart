import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/apis/fcm/fcm_api.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';

abstract class MessagesRemoteDataSource {
  Future<void> sendMessage({
    required String phoneNumber,
    required LastMessageModel lastMessageModel,
    required MessageModel messageModel,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber});

  Future<Map<String, dynamic>> pushNotification({
    required Map<String, dynamic> fcmBody,
  });
}

class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final FirebaseHelper firebaseHelper;
  final FcmApi fcmApi;

  MessagesRemoteDataSourceImpl(
      {required this.firebaseHelper, required this.fcmApi});
  @override
  Future<void> sendMessage({
    required String phoneNumber,
    required LastMessageModel lastMessageModel,
    required MessageModel messageModel,
  }) {
    return firebaseHelper.sendMessage(
      phoneNumber: phoneNumber,
      lastMessageModel: lastMessageModel,
      messageModel: messageModel,
    );
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber}) {
    return firebaseHelper.getMessages(phoneNumber: phoneNumber);
  }

  @override
  Future<Map<String, dynamic>> pushNotification(
      {required Map<String, dynamic> fcmBody}) {
    return fcmApi.pushNotification(fcmBody: fcmBody);
  }
}
