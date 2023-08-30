import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/data/models/contact_story_model/contact_story_model.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';

abstract class StoriesRemoteDataSource {
  Future<void> setLastStory({required StoryModel storyModel});
  Future<void> sendStory({required StoryModel storyModel});
  Stream<QuerySnapshot<Map<String, dynamic>>> getStories();
  Future<void> deleteStory({required String storyId});
  Stream<QuerySnapshot<Map<String, dynamic>>> getContactsLastStories();
  Future<List<ContactStoryModel>?> getContactsCurrentStories(
      {required List<UserData> users});
  Future<void> updateLastStory({required StoryModel storyModel});
  Future<void> deleteLastStory();
  Future<void> updateStory(
      {required StoryModel storyModel, required String phoneNumber});
}

class StoriesRemoteDataSourceImpl implements StoriesRemoteDataSource {
  final FirebaseHelper firebaseHelper;

  StoriesRemoteDataSourceImpl({required this.firebaseHelper});
  @override
  Future<void> sendStory({required StoryModel storyModel}) {
    return firebaseHelper.sendStory(storyModel: storyModel);
  }

  @override
  Future<void> setLastStory({required StoryModel storyModel}) {
    return firebaseHelper.setLastStory(storyModel: storyModel);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getStories() {
    return firebaseHelper.getStories();
  }

  @override
  Future<void> deleteStory({required String storyId}) {
    return firebaseHelper.deleteStory(storyId: storyId);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getContactsLastStories() {
    return firebaseHelper.getContactsLastStories();
  }

  @override
  Future<List<ContactStoryModel>?> getContactsCurrentStories(
      {required List<UserData> users}) {
    return firebaseHelper.getContactsCurrentStories(users: users);
  }

  @override
  Future<void> updateLastStory({required StoryModel storyModel}) {
    return firebaseHelper.updateLastStory(storyModel: storyModel);
  }

  @override
  Future<void> deleteLastStory() {
    return firebaseHelper.deleteLastStory();
  }

  @override
  Future<void> updateStory(
      {required StoryModel storyModel, required String phoneNumber}) {
    return firebaseHelper.updateStory(
        storyModel: storyModel, phoneNumber: phoneNumber);
  }
}
