import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/data/models/viewer_model/viewer_model.dart';
import 'package:final_nuntius/features/stories/data/repositories/stories_repository.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/my_story_viewers/viewers_bottom_sheet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/story_view.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

part 'stories_state.dart';
part 'stories_cubit.freezed.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoriesRepository storiesRepository;
  final AuthRepository authRepository;

  StoriesCubit({required this.storiesRepository, required this.authRepository})
      : super(const StoriesState.initial());

  static StoriesCubit get(context) => BlocProvider.of(context);

  List<String> phones = [];
  void getPhones(List<String> phones) {
    this.phones = phones;
    emit(const StoriesState.getPhones());
  }

  TextEditingController? controller;
  void initAddTextStory() {
    controller = TextEditingController();
    emit(const StoriesState.initAddTextStory());
  }

  void disposeAddTextStory() {
    controller!.dispose();
    emit(const StoriesState.disposeAddTextStory());
  }

  ImagePicker picker = ImagePicker();
  double filePercentage = 0.0;
  File? storyFile;
  double width = 0.0;
  double height = 0.0;

  Future<void> pickStoryImage() async {
    emit(const StoriesState.pickStoryMediaLoading());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      storyFile = File(pickedFile.path);
      final image = await decodeImageFromList(storyFile!.readAsBytesSync());
      width = image.width + 0.0;
      height = image.height + 0.0;
      emit(const StoriesState.pickStoryImage());
    } else {
      debugPrint("NOT SELECTED");
      emit(const StoriesState.pickStoryImageError());
    }
  }

  Future<void> pickStoryVideo() async {
    emit(const StoriesState.pickStoryMediaLoading());
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      storyFile = File(pickedFile.path);
      emit(const StoriesState.pickStoryVideo());
    } else {
      debugPrint("NOT SELECTED");
      emit(const StoriesState.pickStoryVideoError());
    }
  }

  String? videoDuration;

  void setVideoDuration(String duration) {
    videoDuration = duration;
    emit(const StoriesState.setVideoDuration());
  }

  // void setImageDimensions() async {
  //   final image = await decodeImageFromList(storyFile!.readAsBytesSync());
  //   width = image.width + 0.0;
  //   height = image.height + 0.0;
  //   emit(const StoriesState.setImageDimensions());
  // }

  void sendStory({String? media, MessageType? mediaType}) async {
    emit(const StoriesState.sendStoryLoading());
    final storyModel = StoryModel(
      id: const Uuid().v4(),
      date: DateTime.now().toString(),
      isImage: mediaType == MessageType.image ? true : false,
      isVideo: mediaType == MessageType.video ? true : false,
      isRead: false,
      videoDuration: videoDuration,
      media: media ?? "",
      phone: HiveHelper.getCurrentUser()!.phone,
      text: controller!.text,
      viewers: [],
      canView: phones,
    );
    final response =
        await storiesRepository.setLastStory(storyModel: storyModel);

    response.fold(
      (failure) {
        emit(StoriesState.sendStoryError(failure.getMessage()));
      },
      (result) async {
        final response =
            await storiesRepository.sendStory(storyModel: storyModel);
        response.fold(
          (failure) {
            emit(StoriesState.sendStoryError(failure.getMessage()));
          },
          (result) {
            controller!.clear();
            width = 0.0;
            height = 0.0;
            emit(const StoriesState.sendStory());
          },
        );
      },
    );
  }

  void sendMediaStory({required MessageType mediaType}) async {
    emit(const StoriesState.sendStoryLoading());
    final response = await authRepository.uploadImageToStorage(
        collectionName: Collections.stories, file: storyFile!);
    response.fold(
      (failure) {
        emit(StoriesState.sendStoryError(failure.getMessage()));
      },
      (result) {
        result!.fold(
          (url) {
            sendStory(media: url, mediaType: mediaType);
          },
          (taskSnapshot) {
            taskSnapshot.listen((event) async {
              switch (event.state) {
                case TaskState.running:
                  emit(const StoriesState.sendStoryLoading());
                  filePercentage = event.bytesTransferred / event.totalBytes;
                  debugPrint("===============> $filePercentage");
                  emit(const StoriesState.getFilePercentage());
                  break;
                case TaskState.paused:
                  break;
                case TaskState.success:
                  final url = await event.ref.getDownloadURL();
                  sendStory(media: url, mediaType: mediaType);
                  break;
                case TaskState.canceled:
                  emit(const StoriesState.sendStoryError(
                      "The operation has been cancelled."));
                  break;
                case TaskState.error:
                  emit(const StoriesState.sendStoryError(
                      "The operation has been failed."));
                  break;
              }
            });
          },
        );
      },
    );
  }

  List<StoryModel> myStories = [];
  void getStories(context) async {
    emit(const StoriesState.getMyStoriesLoading());
    final response = await storiesRepository.getStories();
    response.fold(
      (failure) {
        emit(StoriesState.getMyStoriesError(failure.getMessage()));
      },
      (snapshots) {
        // List<StoryModel> recentStories = [];
        // List<StoryModel> viewedStories = [];
        // List<UserData> viewedInfo = [];
        // List<UserData> recentInfo = [];
        snapshots.listen((event) async {
          emit(const StoriesState.initAddTextStory());
          List<StoryModel> myStories = [];
          for (var doc in event.docs) {
            final story = StoryModel.fromJson(doc.data());
            myStories.add(story);
          }
          this.myStories = myStories;
          print("================>${this.myStories.length}");
          emit(const StoriesState.getMyStories());
        });
      },
    );
  }

  StoryController? storyController;
  List<StoryItem> storyItems = [];

  void initStoryView({
    required List<StoryModel> stories,
    required BuildContext context,
    bool isDeleted = false,
  }) {
    storyController = StoryController();
    handleStoryItems(stories: stories, context: context);
    if (isDeleted) {
      emit(const StoriesState.initStoryView());
    } else {
      emit(const StoriesState.deleteStory());
    }
  }

  void disposeStoryView() {
    storyController!.dispose();
    emit(const StoriesState.disposeStoryView());
  }

  void handleStoryItems({
    required List<StoryModel> stories,
    required BuildContext context,
  }) {
    storyItems = [];
    for (int i = 0; i < stories.length; i++) {
      if (stories[i].media != "") {
        if (stories[i].isImage == true) {
          storyItems.add(StoryItem.pageImage(
            url: stories[i].media!,
            controller: storyController!,
            caption: stories[i].text == "" ? null : stories[i].text,
          ));
        } else {
          storyItems.add(StoryItem.pageVideo(
            stories[i].media!,
            controller: storyController!,
            duration: AppFunctions.durationParser(
                duration: stories[i].videoDuration!),
            caption: stories[i].text == "" ? null : stories[i].text,
          ));
        }
      } else {
        storyItems.add(StoryItem.text(
          title: stories[i].text!,
          backgroundColor: AppColors.black,
        ));
      }
    }
  }

  int storyIndex = 0;
  void changeStoryIndex({required int index}) {
    emit(const StoriesState.changeStoryIndexLoading());
    storyIndex = index;
    emit(const StoriesState.changeStoryIndex());
  }

  void resetStoryIndex() {
    storyIndex = 0;
    emit(const StoriesState.resetStoryIndex());
  }

  void showStoryViewers({
    required BuildContext context,
    required List<ViewerModel> viewers,
  }) {
    storyController!.pause();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        List<UserData> users = [];
        List<String> viewsDateTime = [];
        for (var viewer in viewers) {
          UserData? userData =
              users.firstWhereOrNull((element) => element.uId == viewer.id);
          if (userData != null) {
            users.add(userData);
          } else {
            UserData notContactUser = UserData(
              uId: viewer.id,
              name: viewer.phoneNumber,
              phone: viewer.phoneNumber,
              image: "",
            );
            users.add(notContactUser);
          }
          viewsDateTime.add(viewer.dateTime!);
        }
        return ViewersBottomSheet(
          users: users,
          viewsDateTime: viewsDateTime,
        );
      },
    ).then((value) => storyController!.play());
  }

  void deleteStory(
      {required BuildContext context,
      required List<StoryModel> stories,
      required String storyId}) async {
    emit(const StoriesState.deleteStoryLoading());
    final response = await storiesRepository.deleteStory(storyId: storyId);
    response.fold(
      (failure) => emit(StoriesState.deleteStoryError(failure.getMessage())),
      (result) {
        if (stories.length == 1) {
          Go.back(context: context);
          Go.back(context: context);
          emit(const StoriesState.deleteStory());
        } else {
          stories.removeAt(storyIndex);
          storyController!.play();
          initStoryView(
            stories: stories,
            context: context,
            isDeleted: true,
          );
        }
      },
    );
  }
}
