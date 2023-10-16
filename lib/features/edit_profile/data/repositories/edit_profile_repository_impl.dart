import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/network/network_info.dart';
import 'package:final_nuntius/features/edit_profile/data/datasources/edit_profile_remote_data_source.dart';
import 'package:final_nuntius/features/edit_profile/data/repositories/edit_profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  final NetworkInfo networkInfo;
  final EditProfileRemoteDataSource editProfileRemoteDataSource;

  EditProfileRepositoryImpl(
      {required this.networkInfo, required this.editProfileRemoteDataSource});
  @override
  Future<Either<Failure, void>> updateProfileData(
      {required Map<String, dynamic> data}) async {
    if (await networkInfo.connected()) {
      try {
        try {
          final response =
              await editProfileRemoteDataSource.updateProfileData(data: data);
          return Right(response);
        } on FirebaseAuthException catch (error) {
          return Left(
              ServerFailure(error: error, type: NetworkErrorTypes.firestore));
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
