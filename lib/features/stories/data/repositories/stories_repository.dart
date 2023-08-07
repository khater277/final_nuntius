import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';

abstract class StoriesRepository {
  Future<Either<Failure, void>> setLastStory({required StoryModel storyModel});
  Future<Either<Failure, void>> sendStory({required StoryModel storyModel});
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getStories();
  Future<Either<Failure, void>> deleteStory({required String storyId});
}
