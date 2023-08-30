import 'dart:io';

import 'package:collection/collection.dart';
import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository.dart';
import 'package:final_nuntius/features/stories/data/models/contact_story_model/contact_story_model.dart';
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

part 'stories_cubit.freezed.dart';
part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoriesRepository storiesRepository;
  final MessagesRepository messagesRepository;

  final AuthRepository authRepository;

  StoriesCubit({
    required this.storiesRepository,
    required this.authRepository,
    required this.messagesRepository,
  }) : super(const StoriesState.initial());

  static StoriesCubit get(context) => BlocProvider.of(context);

  List<String> phones = [];
  List<UserData> users = [];
  void getPhones(List<String> phones, List<UserData> users) {
    this.phones = phones;
    this.users = users;
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
      viewersPhones: [],
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
          emit(const StoriesState.getMyStoriesLoading());
          List<StoryModel> myStories = [];
          for (var doc in event.docs) {
            final story = StoryModel.fromJson(doc.data());
            myStories.add(story);
          }
          this.myStories = myStories;
          print("================>${this.myStories.length}");
          // emit(const StoriesState.getMyStories());
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
    required List<Map<String, dynamic>> viewers,
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
          final viewerModel = ViewerModel.fromJson(viewer);
          UserData? userData = users
              .firstWhereOrNull((element) => element.uId == viewerModel.id);
          if (userData != null) {
            users.add(userData);
          } else {
            UserData notContactUser = UserData(
              uId: viewerModel.id,
              name: viewerModel.phoneNumber,
              phone: viewerModel.phoneNumber,
              image: "",
            );
            users.add(notContactUser);
            viewsDateTime.add(viewerModel.dateTime!);
          }
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
      (result) async {
        if (stories.length == 1) {
          final response = await storiesRepository.deleteLastStory();
          response.fold(
            (failure) =>
                emit(StoriesState.deleteStoryError(failure.getMessage())),
            (result) {
              Go.back(context: context);
              Go.back(context: context);
              emit(const StoriesState.deleteStory());
            },
          );
        } else {
          stories.removeAt(storyIndex);
          final response =
              await storiesRepository.updateLastStory(storyModel: stories.last);
          response.fold(
            (failure) =>
                emit(StoriesState.deleteStoryError(failure.getMessage())),
            (result) {
              storyController!.play();
              initStoryView(
                stories: stories,
                context: context,
                isDeleted: true,
              );
            },
          );
        }
      },
    );
  }

  ContactStoryModel? contactStoryModel;
  List<ContactStoryModel> contactsStories = [];
  List<ContactStoryModel> recentStories = [];
  List<ContactStoryModel> viewedStories = [];
  List<String> contactsStoriesPhones = [];
  bool empty = true;
  void openContactStory({required ContactStoryModel contactStoryModel}) {
    this.contactStoryModel = contactStoryModel;
    emit(const StoriesState.openContactStory());
  }

  void getContactsCurrentStories(
      {required List<UserData> users, bool? isStream}) async {
    if (isStream != true) {
      emit(const StoriesState.getContactsCurrentStoriesLoading());
    }
    final response =
        await storiesRepository.getContactsCurrentStories(users: users);
    response.fold(
      (failure) => emit(
          StoriesState.getContactsCurrentStoriesError(failure.getMessage())),
      (stories) {
        if (stories!.isEmpty) {
          empty = true;
        } else {
          empty = false;
        }
        contactsStories = stories;
        viewedStories = [];
        recentStories = [];
        for (var contactStory in stories) {
          if (contactStory.stories!.last.viewersPhones!
              .contains(HiveHelper.getCurrentUser()!.phone)) {
            viewedStories.add(contactStory);
          } else {
            recentStories.add(contactStory);
          }
        }
        viewedStories.sort(
          (a, b) => DateTime.parse(a.stories!.last.date!)
              .compareTo(DateTime.parse(b.stories!.last.date!)),
        );

        recentStories.sort(
          (a, b) => DateTime.parse(a.stories!.last.date!)
              .compareTo(DateTime.parse(b.stories!.last.date!)),
        );

        recentStories = recentStories.reversed.toList();
        viewedStories = viewedStories.reversed.toList();

        emit(const StoriesState.getContactsCurrentStories());
      },
    );
  }

  void contactsStoriesChanged() async {
    final response = await storiesRepository.getContactsLastStories();
    response.fold(
      (failure) =>
          emit(StoriesState.contactsStoriesChangedError(failure.getMessage())),
      (stream) {
        stream.listen((event) {
          if (!empty) {
            emit(const StoriesState.contactsStoriesChanged());
          }
          getContactsCurrentStories(users: users, isStream: true);
        });
      },
    );
  }

  TextEditingController? replyController;
  void initReplyToStory() {
    replyController = TextEditingController();
    emit(const StoriesState.initReplyToStory());
  }

  void viewContactStory(
      {required StoryModel storyModel, required String phoneNumber}) async {
    emit(const StoriesState.viewContactStoryLoading());
    storyModel.viewers!.add(ViewerModel(
      id: HiveHelper.getCurrentUser()!.uId,
      phoneNumber: HiveHelper.getCurrentUser()!.phone,
      dateTime: DateTime.now().toString(),
    ).toJson());

    storyModel.viewersPhones!.add(HiveHelper.getCurrentUser()!.phone!);

    // print("=========>${storyModel.toJson()}");
    final response = await storiesRepository.updateStory(
      storyModel: storyModel,
      phoneNumber: contactStoryModel!.user!.phone!,
    );

    response.fold(
      (failure) => null,
      (result) {
        emit(const StoriesState.viewContactStory());
        contactsStoriesChanged();
        // emit(const StoriesState.viewContactStory());
      },
    );
  }

  void replyToStory({
    required UserData user,
    required StoryModel story,
  }) async {
    emit(const StoriesState.replyToStoryLoading());

    MessageModel messageModel = MessageModel(
      senderId: HiveHelper.getCurrentUser()!.uId,
      receiverId: user.uId,
      message: replyController!.text,
      date: DateTime.now().toString(),
      media: "",
      isImage: false,
      isVideo: false,
      isDoc: false,
      isStoryReply: true,
      storyMedia: story.media,
      storyDate: story.date,
      isStoryImageReply: story.isImage,
    );

    LastMessageModel lastMessageModel = LastMessageModel(
      token: user.token,
      image: user.image,
      senderID: messageModel.senderId,
      receiverID: messageModel.receiverId,
      message: messageModel.message,
      date: messageModel.date,
      media: messageModel.media,
      isImage: messageModel.isImage,
      isVideo: messageModel.isVideo,
      isDoc: messageModel.isDoc,
      isDeleted: messageModel.isDeleted,
      isRead: false,
    );

    final response = await messagesRepository.sendMessage(
      phoneNumber: user.phone!,
      lastMessageModel: lastMessageModel,
      messageModel: messageModel,
    );

    response.fold(
      (failure) => emit(StoriesState.replyToStoryError(failure.getMessage())),
      (result) {
        emit(const StoriesState.replyToStory());
      },
    );
  }
}
