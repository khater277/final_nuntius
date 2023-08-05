import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'messages_cubit.freezed.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepository messagesRepository;
  final AuthRepository authRepository;
  MessagesCubit({
    required this.messagesRepository,
    required this.authRepository,
  }) : super(const MessagesState.initial());

  static MessagesCubit get(context) => BlocProvider.of(context);

  TextEditingController? messageController;
  ScrollController? scrollController;
  UserData? user;
  void initMessages({
    required UserData user,
    required HomeCubit homeCubit,
  }) {
    messageController = TextEditingController();
    scrollController = ScrollController();
    this.user = user;
    homeCubit.initUser(user: user);
    getMessages(isInit: true);
  }

  void disposeMessages({required HomeCubit homeCubit}) {
    // messageController!.dispose();
    // scrollController!.dispose();
    // user = null;
    messageType = null;
    file = null;
    homeCubit.disposeUser();
    emit(const MessagesState.disposeControllers());
  }

  void getMessages({bool? isInit}) async {
    emit(const MessagesState.getMessagesLoading());
    final response =
        await messagesRepository.getMessages(phoneNumber: user!.phone!);
    response.fold(
      (failure) {
        emit(MessagesState.getMessagesError(failure.getMessage()));
      },
      (snapshots) {
        snapshots.listen((event) {
          List<MessageModel> messages = [];
          for (var doc in event.docs) {
            messages.add(MessageModel.fromJson(doc.data()));
          }
          if (isInit == true) scrollDown();
          emit(MessagesState.getMessages(messages));
        });
      },
    );
  }

  Future<void> sendMessage({
    String? media,
    MessageType? messageType,
  }) async {
    if (media == null) emit(const MessagesState.sendMessageLoading());

    MessageModel messageModel = MessageModel(
      senderId: await SharedPrefHelper.getUid(),
      receiverId: user!.uId,
      message: messageType == MessageType.doc
          ? Uri.file(file!.path).pathSegments.last
          : messageController!.text,
      date: DateTime.now().toString(),
      media: media,
      isImage: messageType == MessageType.image ? true : false,
      isVideo: messageType == MessageType.video ? true : false,
      isDoc: messageType == MessageType.doc ? true : false,
    );

    LastMessageModel lastMessageModel = LastMessageModel(
      token: user!.token,
      image: user!.image,
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
      phoneNumber: user!.phone!,
      lastMessageModel: lastMessageModel,
      messageModel: messageModel,
    );

    response.fold(
      (failure) => emit(MessagesState.sendMessageError(failure.getMessage())),
      (result) async {
        messageController!.clear();
        scrollDown();
        messageType = null;
        file = null;
        emit(const MessagesState.sendMessage());
        if (user!.token != HiveHelper.getCurrentUser()!.token) {
          final x = await messagesRepository.pushNotification(
              fcmBody: AppFunctions.getFcmBody(user: user!));
          x.fold((l) => print("NOT SENT"), (r) => print("SENT"));
        }
      },
    );
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      scrollController!.animateTo(
        scrollController!.position.maxScrollExtent + AppHeight.h40,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  ImagePicker picker = ImagePicker();
  MessageType? messageType;
  File? file;
  double? filePercentage;

  void closeMediaContainer() {
    messageType = null;
    file = null;
    emit(const MessagesState.closeMediaContainer());
  }

  Future<void> pickMessageImage() async {
    emit(const MessagesState.pickMessageImageLoading());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      messageType = MessageType.image;
      emit(const MessagesState.pickMessageImage());
    } else {
      debugPrint("NOT SELECTED");
      emit(const MessagesState.pickMessageImageError("NOT SELECTED"));
    }
  }

  Future<void> pickMessageVideo() async {
    emit(const MessagesState.pickMessageVideoLoading());
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      messageType = MessageType.video;
      emit(const MessagesState.pickMessageVideo());
    } else {
      debugPrint("NOT SELECTED");
      emit(const MessagesState.pickMessageVideoError("NOT SELECTED"));
    }
  }

  Future<void> pickMessageFile() async {
    emit(const MessagesState.pickMessageFileLoading());
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File pickedFile = File(result.files.single.path!);
      file = File(pickedFile.path);
      messageType = MessageType.doc;
      emit(const MessagesState.pickMessageFile());
    } else {
      debugPrint("NOT SELECTED");
      emit(const MessagesState.pickMessageFileError("NOT SELECTED"));
    }
  }

  void sendMediaMessage() async {
    emit(const MessagesState.sendMessageLoading());
    final response = await authRepository.uploadImageToStorage(
        collectionName: Collections.messageImages, file: file!);
    response.fold(
      (failure) {
        emit(MessagesState.sendMessageError(failure.getMessage()));
      },
      (result) {
        result!.fold(
          (url) {
            sendMessage(
              media: url,
              messageType: messageType!,
            );
          },
          (taskSnapshot) {
            taskSnapshot.listen((event) async {
              switch (event.state) {
                case TaskState.running:
                  emit(const MessagesState.sendMessageLoading());
                  filePercentage = event.bytesTransferred / event.totalBytes;
                  debugPrint("===============> $filePercentage");
                  emit(const MessagesState.getFilePercentage());
                  break;
                case TaskState.paused:
                  break;
                case TaskState.success:
                  sendMessage(
                    media: await event.ref.getDownloadURL(),
                    messageType: messageType!,
                  );
                  break;
                case TaskState.canceled:
                  emit(const MessagesState.sendMessageError(
                      "The operation has been cancelled."));
                  break;
                case TaskState.error:
                  emit(const MessagesState.sendMessageError(
                      "The operation has been failed."));
                  break;
              }
            });
          },
        );
      },
    );
  }
}
