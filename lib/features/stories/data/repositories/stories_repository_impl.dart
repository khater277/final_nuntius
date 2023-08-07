import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/network/network_info.dart';
import 'package:final_nuntius/features/stories/data/datasources/stories_remote_data_source.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/data/repositories/stories_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesRemoteDataSource storiesRemoteDataSource;
  final NetworkInfo networkInfo;

  StoriesRepositoryImpl({
    required this.storiesRemoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> sendStory(
      {required StoryModel storyModel}) async {
    if (await networkInfo.connected()) {
      try {
        final response =
            storiesRemoteDataSource.sendStory(storyModel: storyModel);
        return Right(response);
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

  @override
  Future<Either<Failure, void>> setLastStory(
      {required StoryModel storyModel}) async {
    if (await networkInfo.connected()) {
      try {
        final response =
            storiesRemoteDataSource.setLastStory(storyModel: storyModel);
        return Right(response);
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

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getStories() async {
    try {
      final response = storiesRemoteDataSource.getStories();
      return Right(response);
    } on FirebaseException catch (error) {
      return Left(
          ServerFailure(error: error, type: NetworkErrorTypes.firestore));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory({required String storyId}) async {
    if (await networkInfo.connected()) {
      try {
        final response = storiesRemoteDataSource.deleteStory(storyId: storyId);
        return Right(response);
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
