import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/data/models/contact_story_model/contact_story_model.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';

abstract class StoriesRepository {
  Future<Either<Failure, void>> setLastStory({required StoryModel storyModel});
  Future<Either<Failure, void>> sendStory({required StoryModel storyModel});
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getStories();

  Future<Either<Failure, void>> deleteStory({required String storyId});
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getContactsLastStories();
  Future<Either<Failure, List<ContactStoryModel>?>> getContactsCurrentStories(
      {required List<UserData> users});
  Future<Either<Failure, void>> updateLastStory(
      {required StoryModel storyModel});
  Future<Either<Failure, void>> deleteLastStory();
  Future<Either<Failure, void>> updateStory(
      {required StoryModel storyModel, required String phoneNumber});
}
