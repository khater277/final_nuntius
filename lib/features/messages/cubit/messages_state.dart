part of 'messages_cubit.dart';

@freezed
class MessagesState with _$MessagesState {
  const factory MessagesState.initial() = _Initial;
  const factory MessagesState.initControllers() = _InitControllers;
  const factory MessagesState.disposeControllers() = _DisposeControllers;
  const factory MessagesState.sendMessageLoading() = _SendMessageLoading;
  const factory MessagesState.sendMessage() = _SendMessage;
  const factory MessagesState.sendMessageError(String errorMsg) =
      _SendMessageError;
  const factory MessagesState.getMessagesLoading() = _GetMessagesLoading;
  const factory MessagesState.getMessages(List<MessageModel> messages) =
      _GetMessages;
  const factory MessagesState.getMessagesError(String errorMsg) =
      _GetMessagesError;
}
