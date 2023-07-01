import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';

abstract class MessagesRemoteDataSource {
  Future<void> sendMessage({
    required String phoneNumber,
    required MessageModel messageModel,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber});
}

class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final FirebaseHelper firebaseHelper;

  MessagesRemoteDataSourceImpl({required this.firebaseHelper});
  @override
  Future<void> sendMessage(
      {required String phoneNumber, required MessageModel messageModel}) {
    return firebaseHelper.sendMessage(
      phoneNumber: phoneNumber,
      messageModel: messageModel,
    );
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String phoneNumber}) {
    return firebaseHelper.getMessages(phoneNumber: phoneNumber);
  }
}
