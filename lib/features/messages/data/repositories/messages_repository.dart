import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';

abstract class MessagesRepository {
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getUser({required String phoneNumber});

  Future<Either<Failure, void>> sendMessage({
    required String phoneNumber,
    required LastMessageModel lastMessageModel,
    required MessageModel messageModel,
  });
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getMessages({required String phoneNumber});

  Future<Either<Failure, Map<String, dynamic>>> pushNotification({
    required Map<String, dynamic> fcmBody,
  });

  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
    required String userPhone,
  });

  Future<Either<Failure, void>> deleteLastMessage({required String userPhone});

  Future<Either<Failure, void>> seeMessage({required String phoneNumber});
}
