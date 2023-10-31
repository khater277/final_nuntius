import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_last_message/chat_last_message.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chats/chat_name_and_date.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chats/swipe_to_delete.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:final_nuntius/features/messages/presentation/screens/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ChatBuilder extends StatelessWidget {
  final UserData user;
  final LastMessageModel lastMessage;
  const ChatBuilder({
    super.key,
    required this.user,
    required this.lastMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(user.uId),
      startActionPane:
          swipeToDelete(context: context, rightPadding: AppWidth.w10),
      endActionPane: swipeToDelete(context: context, leftPadding: AppWidth.w10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppHeight.h10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  Go.to(context: context, screen: MessagesScreen(user: user)),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    UserImage(
                      image: user.image!,
                      isChat: true,
                    ),
                    SizedBox(width: AppWidth.w5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ChatNameAndDate(
                            name: user.name!,
                            date: DateFormat('d MMM , yyyy')
                                .format(DateTime.parse(lastMessage.date!)),
                          ),
                          SizedBox(height: AppHeight.h2),
                          ChatLastMessage(
                            messageType: lastMessage.isImage == true
                                ? MessageType.image
                                : lastMessage.isVideo == true
                                    ? MessageType.video
                                    : lastMessage.isDoc == true
                                        ? MessageType.doc
                                        : lastMessage.isDeleted == true
                                            ? MessageType.deleted
                                            : MessageType.text,
                            message: lastMessage.message!,
                            isMyMessage: lastMessage.senderID ==
                                HiveHelper.getCurrentUser()!.uId,
                            isRead: lastMessage.isRead!,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
