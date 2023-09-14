import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/calls/data/datasources/calls_remote_data_source.dart';
import 'package:final_nuntius/features/calls/data/repositories/calls_repository.dart';
import 'package:final_nuntius/features/messages/data/models/agora_token/agora_token_model/agora_token_model.dart';

class CallsRepositoryImpl implements CallsRepository {
  final CallsRemoteDataSource callsRemoteDataSource;

  CallsRepositoryImpl({required this.callsRemoteDataSource});
  @override
  Future<Either<Failure, AgoraTokenModel>> generateToken(
      {required String channel, required String uid}) async {
    try {
      final response =
          await callsRemoteDataSource.generateToken(channel: channel, uid: uid);
      return Right(response);
    } on DioException catch (error) {
      return Left(ServerFailure(
        error: error,
        type: NetworkErrorTypes.api,
      ));
    }
  }
}
