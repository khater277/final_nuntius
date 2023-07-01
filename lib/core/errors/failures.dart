import 'package:equatable/equatable.dart';
import 'package:final_nuntius/core/errors/api/network_exceptions.dart';
import 'package:final_nuntius/core/errors/firebase/auth/auth_exceptions.dart';
import 'package:final_nuntius/core/errors/firebase/firestore/firestore_exceptions.dart';
import 'package:final_nuntius/core/errors/firebase/storage/storage_exceptions.dart';

enum NetworkErrorTypes { api, auth, firestore, storage }

abstract class Failure extends Equatable {
  String getMessage();
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final Exception error;
  final NetworkErrorTypes type;

  ServerFailure({
    required this.error,
    required this.type,
  });

  String handleException(e) {
    String result;
    switch (type) {
      case NetworkErrorTypes.api:
        result = NetworkExceptions.getErrorMessage(
            NetworkExceptions.getDioException(error));
        break;
      case NetworkErrorTypes.auth:
        result = AuthExceptionHandler.generateExceptionMessage(
            AuthExceptionHandler.handleException(error));
        break;
      case NetworkErrorTypes.firestore:
        result = FirestoreExceptionHandler.generateExceptionMessage(
            FirestoreExceptionHandler.handleException(error));
        break;
      case NetworkErrorTypes.storage:
        result = StorageExceptionHandler.generateExceptionMessage(
            StorageExceptionHandler.handleException(error));
        break;
      default:
        result = e.runtimeType.toString();
    }
    return result;
  }

  @override
  String getMessage() => handleException(error);
}
