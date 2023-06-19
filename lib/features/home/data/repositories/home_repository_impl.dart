import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/network/network_info.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/home/data/datasources/home_remote_data_source.dart';
import 'package:final_nuntius/features/home/data/repositories/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl(
      {required this.homeRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<UserData>>> getAllUsersFromFirestore() async {
    if (await networkInfo.connected()) {
      try {
        final response = await homeRemoteDataSource.getAllUsersFromFirestore();
        if (response != null) {
          return Right(response);
        } else {
          FirebaseAuthException exception =
              FirebaseAuthException(code: 'not-found');
          return Left(ServerFailure(
              error: exception, type: NetworkErrorTypes.firestore));
        }
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
}
