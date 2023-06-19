import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';

abstract class CallsRepository {
  Future<Either<Failure, String>> generateToken();
}
