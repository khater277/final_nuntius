import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/network/network_info.dart';
import 'package:final_nuntius/features/chats/data/datasources/chats_remote_data_source.dart';
import 'package:final_nuntius/features/chats/data/repositories/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsRemoteDataSource chatsRemoteDataSource;
  final NetworkInfo networkInfo;

  ChatsRepositoryImpl(
      {required this.chatsRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getChats() async {
    // if (await networkInfo.connected()) {
    try {
      final response = chatsRemoteDataSource.getChats();
      return Right(response);
    } on FirebaseException catch (error) {
      return Left(
          ServerFailure(error: error, type: NetworkErrorTypes.firestore));
    }
    // } else {
    //   FirebaseException error = FirebaseException(
    //     plugin: '',
    //     code: 'no-internet-connection',
    //   );
    //   return Left(ServerFailure(
    //     error: error,
    //     type: NetworkErrorTypes.firestore,
    //   ));
    // }
  }
}
