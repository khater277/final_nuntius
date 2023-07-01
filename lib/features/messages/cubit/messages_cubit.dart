import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages_cubit.freezed.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepository messagesRepository;
  MessagesCubit({required this.messagesRepository})
      : super(const MessagesState.initial());

  static MessagesCubit get(context) => BlocProvider.of(context);

  TextEditingController? messageController;
  ScrollController? scrollController;
  UserData? user;
  void initMessages({required UserData user}) {
    messageController = TextEditingController();
    scrollController = ScrollController();
    this.user = user;
    getMessages();
  }

  void disposeMessages() {
    messageController!.dispose();
    scrollController!.dispose();
    emit(const MessagesState.disposeControllers());
  }

  Future<void> sendMessage({
    required String phoneNumber,
  }) async {
    emit(const MessagesState.sendMessageLoading());
    MessageModel messageModel = MessageModel(
      senderId: await SharedPrefHelper.getUid(),
      receiverId: user!.uId,
      message: messageController!.text,
      date: DateTime.now().toString(),
    );
    final response = await messagesRepository.sendMessage(
      phoneNumber: phoneNumber,
      messageModel: messageModel,
    );

    response.fold(
      (failure) => emit(MessagesState.sendMessageError(failure.getMessage())),
      (result) {
        messageController!.clear();
        emit(const MessagesState.sendMessage());
      },
    );
  }

  void getMessages() async {
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
          Future.delayed(const Duration(milliseconds: 500))
              .then((value) => scrollController!.animateTo(
                    scrollController!.position.maxScrollExtent + AppHeight.h40,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  ));
          emit(MessagesState.getMessages(messages));
        });
      },
    );
  }
}
