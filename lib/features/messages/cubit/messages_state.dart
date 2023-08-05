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
  const factory MessagesState.pickMessageImageLoading() =
      _PickMessageImageLoading;
  const factory MessagesState.pickMessageImage() = _PickMessageImage;
  const factory MessagesState.pickMessageImageError(String errorMsg) =
      _PickMessageImageError;
  const factory MessagesState.pickMessageVideoLoading() =
      _PickMessageVideoLoading;
  const factory MessagesState.pickMessageVideo() = _PickMessageVideo;
  const factory MessagesState.pickMessageVideoError(String errorMsg) =
      _PickMessageVideoError;
  const factory MessagesState.pickMessageFileLoading() =
      _PickMessageFileLoading;
  const factory MessagesState.pickMessageFile() = _PickMessageFile;
  const factory MessagesState.pickMessageFileError(String errorMsg) =
      _PickMessageFileError;
  const factory MessagesState.closeMediaContainer() = _CloseMediaContainer;
  const factory MessagesState.getFilePercentage() = _GetFilePercentage;
}
