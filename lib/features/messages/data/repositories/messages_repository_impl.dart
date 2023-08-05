import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/network/network_info.dart';
import 'package:final_nuntius/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource messagesRemoteDataSource;
  final NetworkInfo networkInfo;

  MessagesRepositoryImpl({
    required this.messagesRemoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> sendMessage(
      {required String phoneNumber,
      required LastMessageModel lastMessageModel,
      required MessageModel messageModel}) async {
    if (await networkInfo.connected()) {
      try {
        final response = messagesRemoteDataSource.sendMessage(
          phoneNumber: phoneNumber,
          lastMessageModel: lastMessageModel,
          messageModel: messageModel,
        );
        return Right(response);
      } on FirebaseException catch (error) {
        return Left(
            ServerFailure(error: error, type: NetworkErrorTypes.firestore));
      }
    } else {
      FirebaseException error = FirebaseException(
        plugin: '',
        code: 'no-internet-connection',
      );
      return Left(ServerFailure(
        error: error,
        type: NetworkErrorTypes.firestore,
      ));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getMessages({required String phoneNumber}) async {
    try {
      final response =
          messagesRemoteDataSource.getMessages(phoneNumber: phoneNumber);
      return Right(response);
    } on FirebaseException catch (error) {
      return Left(
          ServerFailure(error: error, type: NetworkErrorTypes.firestore));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> pushNotification(
      {required Map<String, dynamic> fcmBody}) async {
    try {
      final response =
          await messagesRemoteDataSource.pushNotification(fcmBody: fcmBody);
      return Right(response);
    } on DioException catch (error) {
      return Left(ServerFailure(error: error, type: NetworkErrorTypes.api));
    }
  }
}
