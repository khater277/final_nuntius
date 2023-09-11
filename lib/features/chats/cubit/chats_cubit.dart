import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/chats/data/repositories/chats_repository.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart';

part 'chats_state.dart';
part 'chats_cubit.freezed.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository chatsRepository;
  ChatsCubit({required this.chatsRepository})
      : super(const ChatsState.initial());

  static ChatsCubit get(context) => BlocProvider.of(context);
  List<UserData> allUsers = HiveHelper.getAllUsers() ?? [];

  void initChats(context) {
    // allUsers = HiveHelper.getAllUsers() ?? [];
    // // allUsers = HomeCubit.get(context).users;
    // emit(const ChatsState.initChats());
  }

  List<LastMessageModel> lastMessages = [];
  List<UserData> users = [];
  void getChats(context) async {
    emit(const ChatsState.getChatsLoading());
    final response = await chatsRepository.getChats();
    response.fold(
      (failure) {
        emit(ChatsState.getChatsError(failure.getMessage()));
      },
      (snapshots) {
        snapshots.listen((event) async {
          emit(const ChatsState.initChats());
          List<LastMessageModel> lastMessages = [];
          List<UserData> users = [];
          for (var doc in event.docs) {
            final phoneNumber = doc.id;
            final lastMessage = LastMessageModel.fromJson(doc.data());
            final user = allUsers.firstWhereOrNull((user) => user.phone == phoneNumber) ??
                UserData(
                  token: lastMessage.token,
                  name: phoneNumber,
                  uId: lastMessage.senderID == await SharedPrefHelper.getUid()
                      ? lastMessage.receiverID
                      : lastMessage.senderID,
                  image: lastMessage.image,
                  phone: phoneNumber,
                  inCall: false,
                );
            lastMessages.add(lastMessage);
            users.add(user);
          }
          this.users = users;
          this.lastMessages = lastMessages;
          emit(ChatsState.getChats(lastMessages, users));
        });
      },
    );
  }
}
