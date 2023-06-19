import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<UserData>>> getAllUsersFromFirestore();
}
