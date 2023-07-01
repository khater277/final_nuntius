import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';

abstract class MessagesRepository {
  Future<Either<Failure, void>> sendMessage({
    required String phoneNumber,
    required MessageModel messageModel,
  });
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getMessages({required String phoneNumber});
}
