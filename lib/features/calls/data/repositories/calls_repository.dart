import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/features/messages/data/models/agora_token/agora_token_model/agora_token_model.dart';

abstract class CallsRepository {
  Future<Either<Failure, AgoraTokenModel>> generateToken(
      {required String channel, required String uid});
  Future<Either<Failure, Map<String, dynamic>>> pushNotification({
    required Map<String, dynamic> fcmBody,
  });

  Future<Either<Failure, void>> addNewCall({
    required String friendPhoneNumber,
    required String callId,
    required CallType callType,
  });

  Future<Either<Failure, void>> updateCall({
    required String callId,
    required String friendPhoneNumber,
  });

  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getCalls();
}
