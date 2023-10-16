import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';

abstract class EditProfileRepository {
  Future<Either<Failure, void>> updateProfileData(
      {required Map<String, dynamic> data});
}
