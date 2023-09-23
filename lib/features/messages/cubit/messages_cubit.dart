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
import 'package:final_nuntius/features/calls/data/repositories/calls_repository.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/delete_message/delete_message_bottom_sheet.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/doc_message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

part 'messages_cubit.freezed.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepository messagesRepository;
  final AuthRepository authRepository;
  final CallsRepository callsRepository;
  MessagesCubit({
    required this.messagesRepository,
    required this.authRepository,
    required this.callsRepository,
  }) : super(const MessagesState.initial());

  static MessagesCubit get(context) => BlocProvider.of(context);

  TextEditingController? messageController;
  ScrollController? scrollController;

  void initMessages({
    required String phoneNumber,
    required HomeCubit homeCubit,
    required UserData user,
  }) async {
    messageController = TextEditingController();
    scrollController = ScrollController();
    this.user = user;
    homeCubit.initUser(user: user);
    getMessages(isInit: true, phoneNumber: phoneNumber);
    getUser(phoneNumber: phoneNumber);
  }

  void disposeMessages({required HomeCubit homeCubit}) {
    // messageController!.dispose();
    scrollController!.dispose();
    // user = null;
    messageType = null;
    file = null;
    homeCubit.disposeUser();
    emit(const MessagesState.disposeControllers());
  }

  UserData? user;
  void getUser({required String phoneNumber}) async {
    final response = await messagesRepository.getUser(phoneNumber: phoneNumber);
    response.fold(
      (failure) => null,
      (stream) {
        stream.listen((event) {
          emit(const MessagesState.getMessagesLoading());
          user = UserData.fromJson(event.data()!);
          emit(const MessagesState.initControllers());
        });
      },
    );
  }

  List<MessageModel> messages = [];
  void getMessages({bool? isInit, required String phoneNumber}) async {
    emit(const MessagesState.getMessagesLoading());
    final response =
        await messagesRepository.getMessages(phoneNumber: user!.phone!);
    response.fold(
      (failure) {
        emit(MessagesState.getMessagesError(failure.getMessage()));
      },
      (snapshots) {
        snapshots.listen((event) {
          emit(const MessagesState.initControllers());
          List<MessageModel> messages = [];
          for (var doc in event.docs) {
            messages.add(MessageModel.fromJson(doc.data()));
          }
          if (isInit == true) scrollDown();
          this.messages = messages;
          // print("==============>${messages.last.message}");
          // this.messages.sort(
          //       (a, b) =>
          //           DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)),
          //     );
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
      date: DateTime.now().toUtc().toString(),
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
          final pushNotification = await messagesRepository.pushNotification(
              fcmBody: AppFunctions.getMessageNotificationFcmBody(user: user!));
          pushNotification.fold((l) => print("NOT SENT"), (r) => print("SENT"));
        }
      },
    );
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (scrollController!.positions.isNotEmpty) {
        scrollController!.animateTo(
          scrollController!.position.maxScrollExtent + AppHeight.h40,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
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

  String openedDocMessageId = "";
  void openDocMessage({required String url, required String id}) async {
    emit(const MessagesState.openDocMessageLoading());
    openedDocMessageId = id;
    DefaultCacheManager defaultCacheManager = DefaultCacheManager();
    try {
      final file =
          await CachedFileControllerService(defaultCacheManager).getFile(url);
      final filePath = file.absolute.path;
      try {
        await OpenFile.open(filePath);
        emit(const MessagesState.openDocMessage());
      } catch (error) {
        emit(const MessagesState.openDocMessageError("can't open file"));
      }
    } catch (error) {
      emit(const MessagesState.openDocMessageError("can't get file"));
    }
  }

  void showDeleteMessageBottomSheet(
      {required BuildContext context, required String messageId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DeleteMessageBottomSheet(
          messageId: messageId,
        );
      },
    );
  }

  void deleteMessage({required String messageId}) async {
    emit(const MessagesState.deleteMessageLoading());
    final response = await messagesRepository.deleteMessage(
      messageId: messageId,
      userPhone: user!.phone!,
    );
    response.fold(
      (failure) => emit(MessagesState.deleteMessageError(failure.getMessage())),
      (result) async {
        if (messageId == messages.last.messageId) {
          final response = await messagesRepository.deleteLastMessage(
              userPhone: user!.phone!);
          response.fold(
            (failure) =>
                emit(MessagesState.deleteMessageError(failure.getMessage())),
            (result) {
              emit(const MessagesState.deleteMessage());
            },
          );
        } else {
          emit(const MessagesState.deleteMessage());
        }
      },
    );
  }

  void generateToken({required CallType callType}) async {
    emit(const MessagesState.generateTokenLoading());
    String channelName = const Uuid().v4();
    final response = await callsRepository.generateToken(
      channel: channelName,
      uid: "0",
    );
    response.fold(
      (failure) => emit(MessagesState.generateTokenError(failure.getMessage())),
      (agoraTokenModel) => emit(
          MessagesState.generateToken(agoraTokenModel.rtcToken!, channelName)),
    );
  }
}
