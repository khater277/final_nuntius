import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/messages/data/models/agora_token/agora_token_model/agora_token_model.dart';

abstract class CallsRepository {
  Future<Either<Failure, AgoraTokenModel>> generateToken(
      {required String channel, required String uid});
}
