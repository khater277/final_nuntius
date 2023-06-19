import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/calls/data/datasources/calls_remote_data_source.dart';
import 'package:final_nuntius/features/calls/data/repositories/calls_repository.dart';

class CallsRepositoryImpl implements CallsRepository {
  final CallsRemoteDataSource callsRemoteDataSource;

  CallsRepositoryImpl({required this.callsRemoteDataSource});
  @override
  Future<Either<Failure, String>> generateToken() async {
    try {
      final response = await callsRemoteDataSource.generateToken();
      return Right(response);
    } on DioException catch (error) {
      return Left(ServerFailure(
        error: error,
        type: NetworkErrorTypes.api,
      ));
    }
  }
}
