import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';

abstract class StoriesRemoteDataSource {
  Future<void> setLastStory({required StoryModel storyModel});
  Future<void> sendStory({required StoryModel storyModel});
  Stream<QuerySnapshot<Map<String, dynamic>>> getStories();
  Future<void> deleteStory({required String storyId});
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
}
